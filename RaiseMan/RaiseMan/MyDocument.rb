#
#  MyDocument.rb
#  RaiseMan
#
#  Created by Marius Soutier on 03.08.11.
#

class MyDocument < NSPersistentDocument
  attr_accessor :employees
  
  def init
  	super
  	if (self != nil)
      @employees = []
  	end
    self
  end

  def windowNibName
    "MyDocument"
  end

  def windowControllerDidLoadNib(aController)
    super
  end
  
  # Add undo to inserting and removing
  
  def insertObject(person, inEmployeesAtIndex:index)
    puts "Adding #{person} at index #{index}"
    undo = undoManager
    undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(index)
    if !undo.isUndoing
      undo.setActionName("Insert Person")
    end
    
    start_observing_person(person)
    @employees.insertObject(person, atIndex:index)
    # or: @employees << person
    puts "Hallo"
  end
  
  def removeObjectFromEmployeesAtIndex(index)
    p = @employees.objectAtIndex(index)
    puts "Removing #{p}"
    undo = undoManager
    undo.prepareWithInvocationTarget(self).insertObject(p, inEmployeesAtIndex:index)
    if !undo.isUndoing
      undo.setActionName("Delete Person")
    end
    
    stop_observing_person(p)
    @employees.removeObjectAtIndex(index)
  end
  
  # Add undo to editing
  
  def start_observing_person(person)
    person.addObserver(self, forKeyPath:"person_name", options:NSKeyValueObservingOptionOld, context:nil) # and what if person changes? only unit tests could catch it
    person.addObserver(self, forKeyPath:"expected_raise", options:NSKeyValueObservingOptionOld, context:nil)
  end
  
  def stop_observing_person(person)
    person.removeObserver(self, forKeyPath:"person_name")
    person.removeObserver(self, forKeyPath:"expected_raise")
  end
  
  def changeKeyPath(keyPath, ofObject:obj, toValue:newValue)
    obj.setValue(newValue, forKeyPath:keyPath)
  end
  
  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:context)
    oldValue = change.objectForKey(NSKeyValueChangeOldKey)
    if oldValue == NSNull.null
      oldValue = nil
    end
    puts "Old value: #{oldValue}"
    
    undo = undoManager
    undo.prepareWithInvocationTarget(self).changeKeyPath(keyPath, ofObject:object, toValue:oldValue)
    undo.setActionName("Edit")
  end
end

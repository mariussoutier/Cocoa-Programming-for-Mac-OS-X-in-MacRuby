#
#  MyDocument.rb
#  RaiseMan
#
#  Created by Marius Soutier on 03.08.11.
#

class MyDocument < NSDocument
  attr_accessor :employees, :table_view, :employee_controller
  
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
  
  ### Add undo to inserting and removing
  
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
    
    # Does not work, too early I guess?
    @table_view.window.makeFirstResponder(@table_view.window)
    @table_view.editColumn(0, row:0, withEvent:nil, select:true)
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
  
  ### Add undo to editing
  
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
  
  def create_employee(sender)
    # Apparently you need all this spam when you use NSArrayController from code
    window = @table_view.window
    editingEnded = window.makeFirstResponder(window)
    if !editingEnded
      puts "Unable to end editing"
      return
    end
    
    undo = undoManager
    if undo.groupingLevel > 0
      undo.endUndoGrouping
      undo.beginUndoGrouping
    end
    
    person = @employee_controller.newObject
    @employee_controller.addObject(person)
    @employee_controller.rearrangeObjects
    row = @employee_controller.arrangedObjects.indexOfObjectIdenticalTo(person)
    # Effectively for this call:
    @table_view.editColumn(0, row:row, withEvent:nil, select:true)
  end
  
  ### Saving, Loading
  
  def dataOfType(type, error:error)
    puts "dataOfType type #{type}"
    @table_view.window.endEditingFor(nil)
    NSKeyedArchiver.archivedDataWithRootObject(@employees)
  end
  
  def readFromData(data, ofType:typeName, error:error)
    puts "About to read data of type #{typeName}"
    objects = nil
    begin
      objects = NSKeyedUnarchiver.unarchiveObjectWithData(data)
    rescue
      if !error.nil?
        dict = NSDictionary.dictionaryWithObject("Data is corrupted", forKey:NSLocalizedFailureReasonErrorKey)
        #dict = { NSLocalizedFailureReasonErrorKey:"Data is corrupted" }
        error = NSError.errorWithDomain(NSOSStatusErrorDomain, code:0, userInfo:dict) #unimpErr
      end
      return false
    end
    @employees = objects
    true
  end
end

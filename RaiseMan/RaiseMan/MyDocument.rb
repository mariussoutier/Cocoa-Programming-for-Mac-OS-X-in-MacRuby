#
#  MyDocument.rb
#  RaiseMan
#
#  Created by Marius Soutier on 03.08.11.
#
#require 'Person'

class MyDocument < NSPersistentDocument
  attr_accessor :employees
  
  def init
  	super
  	if (self != nil)
      # Add your subclass-specific initialization here.
      # If an error occurs here, return nil.
      @employees = []
  	end
    self
  end

  def windowNibName
    # Override returning the nib file name of the document
    # If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    "MyDocument"
  end

  def windowControllerDidLoadNib(aController)
    super
    # Add any code here that needs to be executed once the windowController has loaded the document's window.
  end
  
  def insertObject(person, inEmployeesAtIndex:index)
    puts "Adding #{person} at index #{index}"
    undo = undoManager
    undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(index)
    if !undo.isUndoing
      undo.setActionName("Insert Person")
    end
    
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
    @employees.removeObjectAtIndex(index)
  end
  
  def start_observing_person(person)
    person.addObserver(self, forKeyPath:"person_name", options:NSKeyValueObservingOptionOld, context:nil) # and what if person changes? only unit tests could catch it
    person.addObserver(self, forKeyPath:"expected_raise", options:NSKeyValueObservingOptionOld, context:nil)
  end
  
  def stop_observing_person(person)
    person.removeObserver(self, forKeyPath:"person_name")
    person.removeObserver(self, forKeyPath:"expected_raise")
  end
end

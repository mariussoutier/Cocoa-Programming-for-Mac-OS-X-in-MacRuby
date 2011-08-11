#
#  Person.rb
#  RaiseMan
#
#  Created by Marius Soutier on 06.08.11.

class Person
  attr_accessor :person_name, :expected_raise
  
  def initialize
    @person_name = "New Person"
    @expected_raise = 5.0
  end
  
  def setNilValueForKey(key)
    puts "#{key} is nil!"
    if key == "expected_raise"
      @expected_raise = 0.0
    else
      super.setNilValueForKey(key)
    end
  end
  
  def to_s
    "Person named #{@person_name} / #{@expected_raise}"
  end
  
  
  # Does this belong in a model class?
  
  def encodeWithCoder(coder)
    # If not inherited from NSObject, you should call super
    # Now we lose the advantage of dynamic typing
    coder.encodeObject(@person_name, forKey:"person_name")
    coder.encodeFloat(@expected_raise, forKey:"expected_raise")
  end
  
  def initWithCoder(coder)
    init
    # Again, have to code to specific types
    @person_name = coder.decodeObjectForKey("person_name")
    @expected_raise = coder.decodeFloatForKey("expected_raise")
    self
  end
end

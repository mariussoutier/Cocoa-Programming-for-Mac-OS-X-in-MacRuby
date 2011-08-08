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
end

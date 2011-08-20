#
#  AppController.rb
#  RaiseMan
#
#  Created by Marius Soutier on 20.08.11.
#

class AppController
  attr_accessor :about_panel
  
  def initialize
    default_values = {}
    color = NSKeyedArchiver.archivedDataWithRootObject(NSColor.yellowColor)
    default_values[:table_background_color] = color
    default_values[:empty_document_flag] = NSNumber.numberWithBool(true)
    NSUserDefaults.standardUserDefaults.registerDefaults(default_values)
  end
  
  def show_preferences_controller(sender)
    if @preference_controller.nil?
      @preference_controller = PreferenceController.new
    end
    @preference_controller.showWindow(self)
  end
  
  # Challenge
  def show_about_panel(sender)
    NSBundle.loadNibNamed("About", owner: self)
  end
  
  def close_about_panel(sender)
    @about_panel.close
  end
  
  def applicationShouldOpenUntitledFile(app)
    NSUserDefaults.standardUserDefaults[:empty_document_flag] == 1 # 0 is also true in Ruby
  end
end

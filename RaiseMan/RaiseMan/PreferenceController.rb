#
#  PreferenceController.rb
#  RaiseMan
#
#  Created by Marius Soutier on 20.08.11.
#

class PreferenceController < NSWindowController
  attr_accessor :color_well, :checkbox
  
  def init
    super.initWithWindowNibName("Preferences")
    self
  end
  
  def table_bg_color
    NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults[:table_background_color])
  end
  
  def empty_doc
    NSUserDefaults.standardUserDefaults[:empty_document_flag]
  end
  
  def windowDidLoad
    @color_well.setColor(table_bg_color)
    @checkbox.setState(empty_doc)
  end
  
  def change_background_color(sender)
    NSUserDefaults.standardUserDefaults[:table_background_color] = NSKeyedArchiver.archivedDataWithRootObject(@color_well.color)
  end
  
  def change_new_empty_doc(sender)
    NSUserDefaults.standardUserDefaults[:empty_document_flag] = @checkbox.state
  end
end

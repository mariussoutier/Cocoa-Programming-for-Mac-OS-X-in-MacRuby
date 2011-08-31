
def localized(key, default_value = "", translation_table = nil)
  NSBundle.mainBundle.localizedStringForKey(key, value: default_value, table: translation_table)
end

#varargs don't work yet
def localized_format(key, translation_table = nil, placeholder_value)
  format_str = localized(key, translation_table)
  puts format_str
  NSString.stringWithFormat(format_str, placeholder_value)
end

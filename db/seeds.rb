%w{
  groups categories groups_to_categories category_regexes users regexes
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
end
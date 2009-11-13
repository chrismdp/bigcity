require 'rubygems'
require File.dirname(__FILE__) + '/highrise'

class BigCity
  def initialize(key, target)
    @target = target
  end

  def contacts
    Highrise::Person.find_all_across_pages
  end
  
  def replace_with(contacts)
    @target.replace_with(contacts)
  end
end


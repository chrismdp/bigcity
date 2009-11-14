lib = File.dirname(__FILE__)

require lib + '/highrise'
require lib + '/google/contact_repository'
require lib + '/google/contact'
require lib + '/google/contact_list'
require lib + '/google/client_login'

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


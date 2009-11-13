require 'hpricot'

class GoogleSharedContacts

  URLS = {
    :client_login => "http://www.google.com:443/accounts/ClientLogin",
    :retrieve_all => "http://www.google.com/m8/feeds/contacts/%s/full"
  }

  def initialize(username, password, domain)
    Net::HTTP.post_form(URI.parse(URLS[:client_login]),
      :accountType => "HOSTED",
      :Email => username,
      :Passwd => password,
      :service => "cp",
      :source => "ChrisParsons-BigCity-1")
    @domain = domain
  end

  def replace_with(contacts)
    delete_all
    create_all(contacts)
  end

  def delete_all
    retrieve_all.each do |contact|
      contact.delete!
    end
  end

  def retrieve_all
    contact_xml = Net::HTTP.get(URI.parse(GoogleSharedContacts::URLS[:retrieve_all] % @domain))
    ContactList.new(contact_xml)
  end

  class ContactList < Array
    def initialize(xml = nil)
      if (xml)
        list = Hpricot(xml)
        (list/"entry").each do |entry|
          self.push(Contact.new(:id => entry/"id", :updated_at => entry/"updated", :email => (entry/"gd:email").first.attributes[:address]))
        end
      end
    end

    def to_atom
      ""
    end
  end

  class Contact < Hash
  end
end

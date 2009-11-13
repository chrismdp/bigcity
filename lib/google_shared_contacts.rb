require 'hpricot'
require 'httparty'

class GoogleSharedContacts

  URLS = {
    :client_login => "https://www.google.com/accounts/ClientLogin",
    :retrieve_all => "http://www.google.com/m8/feeds/contacts/%s/full"
  }

  def initialize(username, password, domain)
    HTTParty.post(URLS[:client_login], :body => {
      :accountType => "HOSTED",
      :Email => username,
      :Passwd => password,
      :service => "cp",
      :source => "ChrisParsons-BigCity-1"})
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
    contact_xml = HTTParty.get(GoogleSharedContacts::URLS[:retrieve_all] % @domain)
    ContactList.new(contact_xml)
  end

  class ContactList < Array
    def initialize(xml = nil)
      super(0)
      if (xml)
        list = Hpricot(xml)
        (list/"entry").each do |entry|
          contact = Contact.new(:id => (entry/"id").inner_html.strip,
                                :updated_at => Time.parse((entry/"updated").inner_html),
                                :email => (entry/"gd:email").first[:address],
                                :edit_url => (entry/"link[@rel='edit']").first[:href].strip)
          self << contact
        end
      end
    end
  end

  class Contact < Hash
    def initialize(hash = {})
      super
      merge! hash
    end
    def delete!
      HTTParty.delete(self[:edit_url])
      true
    end
  end
end

require 'hpricot'
require 'httparty'

module Google
  class ContactRepository

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
      contact_xml = HTTParty.get(Google::ContactRepository::URLS[:retrieve_all] % @domain)
      Google::ContactList.new(contact_xml)
    end
  end
end

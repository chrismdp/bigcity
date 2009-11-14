require 'hpricot'
require 'httparty'

module Google
  class ContactRepository

    URL = {
      :retrieve_all => "http://www.google.com/m8/feeds/contacts/%s/full",
      :create => "http://www.google.com/m8/feeds/contacts/%s/full"
    }

    def initialize(token, domain)
      @token = token
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
      contact_xml = HTTParty.get(URL[:retrieve_all] % @domain, :headers => { "Authorization" => "GoogleLogin #{@token}"})
      Google::ContactList.new(contact_xml)
    end

    def create_all(contact_list)
      contact_list.each do |contact|
        create(contact)
      end
    end

    def create(contact)
      HTTParty.post(URL[:create] % @domain, :body => contact.to_xml, :headers => { "Authorization" => "GoogleLogin #{@token}"})
    end
  end
end

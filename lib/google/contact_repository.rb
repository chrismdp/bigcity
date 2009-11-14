require 'hpricot'
require 'httparty'

module Google
  class ContactRepository

    URLS = {
      :retrieve_all => "http://www.google.com/m8/feeds/contacts/%s/full"
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
      contact_xml = HTTParty.get(Google::ContactRepository::URLS[:retrieve_all] % @domain, :headers => { "Authorization" => "GoogleLogin #{@token}"})
      Google::ContactList.new(contact_xml)
    end
  end
end

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
        delete(contact)
      end
    end

    def delete(contact)
      HTTParty.delete(contact[:edit_url], :headers => { "Authorization" => "GoogleLogin auth=#{@token}"})
      true
    end

    def retrieve_all
      contact_xml = HTTParty.get(URL[:retrieve_all] % @domain, :headers => { "Authorization" => "GoogleLogin auth=#{@token}"})
      Google::ContactList.new(contact_xml)
    end

    def create_all(contact_list)
      contact_list.each do |contact|
        create(contact)
      end
    end

    def create(contact)
      HTTParty.post(URL[:create] % @domain, :body => contact.to_atom, :headers => { "Content-type" => "application/atom+xml", "Authorization" => "GoogleLogin auth=#{@token}"})
    end
  end
end

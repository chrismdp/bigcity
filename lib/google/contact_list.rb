module Google
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
end

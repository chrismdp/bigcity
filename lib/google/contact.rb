module Google
  class Contact < Hash
    def initialize(hash = {})
      super
      merge! hash
    end
    def to_atom
      xml = Builder::XmlMarkup.new
      xml.tag!(:"atom:entry",
               "xmlns:atom" => "http://www.w3.org/2005/Atom",
               "xmlns:gd" => "http://schemas.google.com/g/2005") do |entry|
        entry.title(self[:title], :type => 'text')
        if (self.include? :email)
          self[:email].each do |location, address|
            entry.tag!(:"gd:email", :rel => "http://schemas.google.com/g/2005##{location.to_s.downcase}", :address => address)
          end
        end
        if (self.include? :phone)
          self[:phone].each do |location, phone|
            entry.tag!(:"gd:phoneNumber", phone, :rel => "http://schemas.google.com/g/2005##{location.to_s.downcase}")
          end
        end
      end
    end
  end
end

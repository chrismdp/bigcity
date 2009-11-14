module Google
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

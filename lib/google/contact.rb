module Google
  class Contact < Hash
    def initialize(hash = {})
      super
      merge! hash
    end
    def to_atom
      "<entry>"
    end
  end
end

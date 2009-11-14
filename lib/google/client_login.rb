require 'httparty'

module Google
  class ClientLogin
    URL = "https://www.google.com/accounts/ClientLogin"

    def self.authenticate(username, password)
      response_string = HTTParty.post(URL, :body => {
        :accountType => "HOSTED",
        :Email => username,
        :Passwd => password,
        :service => "cp",
        :source => "ChrisParsons-BigCity-1"})
      response_string.each_line do |line|
        name, value = line.split('=')
        return value.chomp if name == "Auth"
      end
      raise "Auth Token not found"
    end
  end
end

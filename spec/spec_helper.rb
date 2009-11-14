$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bigcity'
require 'google/contact_repository'
require 'google/contact_list'
require 'google/contact'

require 'spec'
require 'spec/autorun'
require 'fakeweb'

Spec::Runner.configure do |config|
  FakeWeb.allow_net_connect = false
  
end

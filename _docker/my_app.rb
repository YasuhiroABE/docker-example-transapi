require './lib/openapiing'

# only need to extend if you want special configuration!
class MyApp < OpenAPIing
  self.configure do |config|
    config.api_version = '1.0.0'
  end
  self.mime_type :yaml, "application/yaml"
end

# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}

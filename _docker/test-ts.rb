#!/usr/bin/ruby

require 'bundler/setup'
Bundler.require
require 'securerandom'

ATS_URI = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=ja"
TEXT = [ { "Text" => "I'm working at home." } ].to_json

headers = {
  'Ocp-Apim-Subscription-Key' => ENV.has_key?("MSATS_KEY") ? ENV["MSATS_KEY"] : "your-secret-key",
  'Ocp-Apim-Subscription-Region' => ENV.has_key?("MSATS_REGION") ? ENV["MSATS_REGION"] : "japaneast",
  'Content-type' => 'application/json',
  'X-ClientTraceId' => SecureRandom.uuid
}

clnt = HTTPClient.new
res = clnt.post(ATS_URI, { :body => TEXT, :header => headers } )
puts res.body
exit(0)


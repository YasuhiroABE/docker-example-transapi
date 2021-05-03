#!/usr/bin/ruby
# coding: utf-8

require 'bundler/setup'
Bundler.require

OPTDEL_LABEL = "delete"
OPTADD_LABEL = "add"
OPTUPD_LABEL = "update"
OPERATIONS = [ OPTDEL_LABEL, OPTADD_LABEL ]
KEY_LABEL = { "field" => { OPTDEL_LABEL => "delete-field",
                           OPTADD_LABEL => "add-field",
                           OPTUPD_LABEL => "replace-field" },
              "field-type" => { OPTDEL_LABEL => "delete-field-type",
                                OPTADD_LABEL => "add-field-type",
                                OPTUPD_LABEL => "replace-field-type" }
            }

SOLR_URL = "http://localhost:8983/solr/solrbook/schema"

operation = nil
if ARGV.length > 0 and OPERATIONS.include?(ARGV[0])
  operation = ARGV.shift
else
  exit 1
end

ARGV.each { |f|
  ret = {}
  json = nil
  open(f) {|data|
    json = JSON.load(data)
  }
  if json and json.keys.length == 1
    ## prepare variables
    data_type = json.keys[0] ## one of "field" or "field-type"
    key_name = KEY_LABEL[data_type][operation]
    ## setup the binary data
    if operation == OPTDEL_LABEL
      ret[key_name] = {}
      ret[key_name]["name"] = json[data_type]["name"]
    elsif operation == OPTADD_LABEL or operation == OPTUPD_LABEL
      ret[key_name] = json[data_type]
    end
  end
  puts ret
  client = HTTPClient.new
  resp = client.post(SOLR_URL, ret.to_json, "Content-Type" => "application/json")
  puts resp.body
}

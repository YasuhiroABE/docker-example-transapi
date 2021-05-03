require './lib/mysolr'
require './lib/myutil'
require './lib/dataapi'
require './lib/deeplapi'
require './lib/gct'

MyApp.add_route('GET', '/dict', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "dict_get", 
  "responseClass" => "void",
  "endpoint" => "/dict", 
  "notes" => "e.g. /dict?q=query-words",
  "parameters" => [
    {
      "name" => "q",
      "description" => "",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    ]}) do
  cross_origin
  # the guts live here
  param = {}
  param[:q] = params.has_key?(:q) ? Rack::Utils.escape_html(params[:q]) : ""
  
  solr = MySolr.new
  solr.search("id:#{param[:q]}").to_json
end 

MyApp.add_route('POST', '/dict', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "dict_post", 
  "responseClass" => "void",
  "endpoint" => "/dict", 
  "notes" => "e.g. /dict?ja=japanese-words&en=english-words",
  "parameters" => [
    {
      "name" => "ja",
      "description" => "",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    {
      "name" => "en",
      "description" => "",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    ]}) do
  cross_origin
  # the guts live here

  ret = { :result => false }

  param = {}
  param[:ja] = params.has_key?(:ja) ? Rack::Utils.escape_html(params[:ja]) : ""
  param[:en] = params.has_key?(:en) ? Rack::Utils.escape_html(params[:en]) : ""

  solr = MySolr.new
  ret[:result]  = solr.add({ :id => param[:ja], :translation => param[:en],
                             :content_edgengram => param[:ja].to_s,
                             :updated => DateTime.now.iso8601 }, false)
end


MyApp.add_route('GET', '/.spec', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "spec_get", 
  "responseClass" => "void",
  "endpoint" => "/.spec", 
  "notes" => "providing the openapi schema YAML file.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


MyApp.add_route('GET', '/trans', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "trans_get", 
  "responseClass" => "void",
  "endpoint" => "/trans", 
  "notes" => "e.g. /trnas?q=query-words",
  "parameters" => [
    {
      "name" => "q",
      "description" => "",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    ]}) do
  cross_origin
  # the guts live here
  param = {}
  param[:q] = params.has_key?(:q) ? Rack::Utils.escape_html(params[:q]) : ""
  
  ## prepare the data structure to be returned.
  ret = {
    :version => "1.0",
    :results => []
  }
  ## escape if query is empty.
  return ret.to_json if param[:q] == ""

  deepl = DeepLAPI.new
  gct = GoogleCloudTranslate.new
  for result in [["deepl", deepl.trans(param[:q])], ["gct", gct.trans(param[:q])]]
    MyUtil::add_data(result[0], ret[:results], result[1])
  end
  ret.to_json
end


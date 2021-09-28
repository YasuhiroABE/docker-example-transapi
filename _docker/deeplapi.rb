# coding: utf-8

require 'cgi'

class DeepLAPI < DataAPI
  DEEPL_TRANS_PATH = "/v2/translate"
  def initialize
    @deepl_host  = ENV.has_key?('DEEPL_HOST') ? ENV['DEEPL_HOST'] : ""
    @auth_key  = ENV.has_key?('DEEPL_AUTHKEY') ? ENV['DEEPL_AUTHKEY'] : ""
  end

  def query_api(query)
    ret = {}
    query = { :auth_key => @auth_key }.merge(query)
    p query
    begin
      client = HTTPClient.new
      url = "https://#{@deepl_host}#{DEEPL_TRANS_PATH}"
      resp = client.get(url, { :query => query })
      ret = JSON.parse(resp.body)
    rescue
      puts "[error] query_api: failed to query: #{:host},#{:path},#{:query}."
      ret = {}
    end
    return ret
  end

  def query_trans(source, to_lang, src_lang)
    q = {
      :text => source,
      :target_lang => to_lang,
      :source_lang => src_lang
    }
    query_api(q)
  end

  def trans(string, to_lang: DeepLAPI::EN, src_lang: DeepLAPI::JA)
    s = CGI::unescapeHTML(string)
    ret = { :original_text => CGI::unescapeHTML(string),
            :translate_text => "",
            :to_lang => to_lang }
    trans_result =  query_trans(s, to_lang, src_lang)
    p trans_result
    ret[:translate_text] = trans_result["translations"][0]["text"]
    return ret
  end
end


require 'json'
require 'uri'
require 'httpclient'

class DeepLAPI < DataAPI
  DEEPL_TRANS_PATH = "/v2/translate"

  def initialize
    @deepl_host  = ENV.has_key?('DEEPL_HOST') ? ENV['DEEPL_HOST'] : ""
    @auth_key  = ENV.has_key?('DEEPL_AUTHKEY') ? ENV['DEEPL_AUTHKEY'] : ""
  end

  def query_api(path, query)
    ret = {}
    query = query != "" ? query + "&auth_key=#{@auth_key}" : "auth_key=#{@auth_key}"
    url = URI::HTTPS.build({:host => @deepl_host, :path => path,
                            :query => query})
    begin
      client = HTTPClient.new
      resp = client.get(url)
      ret = JSON.parse(resp.body)
    rescue
      puts "[error] query_api: failed to query: #{:host},#{:path},#{:query}."
      ret = {}
    end
    return ret
  end

  def query_trans(source, to_lang, src_lang)
    q = "text=#{source}&target_lang=#{to_lang}&source_lang=#{src_lang}"
    query_api(DeepLAPI::DEEPL_TRANS_PATH, q)
  end

  def trans(string, to_lang: DeepLAPI::EN, src_lang: DeepLAPI::JA)
    ret = { :original_text => string,
            :translate_text => "",
            :to_lang => to_lang }
    trans_result =  query_trans(string, to_lang, src_lang)
    ret[:translate_text] = trans_result["translations"][0]["text"]
    return ret
  end
end

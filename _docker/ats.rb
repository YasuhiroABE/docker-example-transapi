
require 'securerandom'

class AzureTranslate < DataAPI
  def initialize
    @ats_host  = ENV.has_key?('ATS_HOST') ? ENV['ATS_HOST'] : "api.cognitive.microsofttranslator.com"
    @ats_path = ENV.has_key?('ATS_PATH') ? ENV['ATS_PATH'] : "/translate"
    @ats_query = { "api-version" => "3.0" }
    @ats_key  = ENV.has_key?('MSATS_KEY') ? ENV['MSATS_KEY'] : ""
    @ats_region  = ENV.has_key?('MSATS_REGION') ? ENV['MSATS_REGION'] : "japaneast"
  end

  ## query: :to => "ja"
  ##        :from => "en"
  ##        :text => ""
  def query_api(query = {})
    ret = {}

    ## prepare URI
    q = @ats_query
    q = q.merge({ :to => query[:to] }) if query.has_key?(:to)
    q = q.merge({ :from => query[:from] }) if query.has_key?(:from)
    query_string = URI.encode_www_form(q)
    url = URI::HTTPS.build({:host => @ats_host, :path => @ats_path,
                            :query => query_string})
    ## prepare Header
    headers = {
      'Ocp-Apim-Subscription-Key' => @ats_key,
      'Ocp-Apim-Subscription-Region' => @ats_region,
      'Content-type' => 'application/json',
      'X-ClientTraceId' => SecureRandom.uuid
    }

    ## prepare Body
    body = [ { "Text" => query.has_key?(:text) ? query[:text] : "" } ].to_json
    begin
      client = HTTPClient.new
      resp = client.post(url, { :body => body, :header => headers } )
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
      :to => to_lang,
      :from => src_lang
    }
    query_api(q)
  end

  def trans(string, to_lang: AzureTranslate::EN, src_lang: AzureTranslate::JA)
    s = CGI.unescapeHTML(string)
    ret = { :original_text => s,
            :translate_text => "",
            :to_lang => to_lang }
    trans_result =  query_trans(s, to_lang, src_lang)
    ret[:translate_text] = trans_result[0]["translations"][0]["text"]
    return ret
  end
end

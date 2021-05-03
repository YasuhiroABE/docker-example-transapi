
require "google/cloud/translate"

class GoogleCloudTranslate < DataAPI
  def initialize
    @project_id  = ENV.has_key?('GOOGLE_PROJECT_ID') ? ENV['GOOGLE_PROJECT_ID'] : ""
  end

  def trans(string, to_lang: GoogleCloudTranslate::EN)
    ret = { :original_text => string,
            :translate_text => "",
            :to_lang => to_lang }
    translate   = Google::Cloud::Translate.translation_v2_service project_id: @project_id
    translation = translate.translate string, to: to_lang
    ret[:translate_text] = translation.text.inspect
    return ret
  end
end

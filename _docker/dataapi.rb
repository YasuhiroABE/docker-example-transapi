
class DataAPI
  JA = "ja"
  EN = "en"
  def initialize
    raise "Nobody can create the instance of DataAPI class."
  end

  def trans(string, to_lang = DataAPI::EN)
    ret = { :original_text => string,
            :translate_text => "",
            :to_lang => to_lang }
    return ret
  end
end

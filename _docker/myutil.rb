class MyUtil
  def self.add_data(label, array, result)
    array.append({ :engine => label,
                   :original_text => result[:original_text],
                   :translate_text => result[:translate_text],
                   :to_lang => result[:to_lang]
                 })
    return array
  end
end

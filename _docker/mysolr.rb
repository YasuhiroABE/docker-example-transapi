# -*- coding:utf-8;mode:ruby -*-

class MySolr
  require 'rsolr'
  def initialize
    @solr_uri = ENV.has_key?("SOLR_URI") ? ENV["SOLR_URI"] : "http://127.0.0.1:8983/solr/solrbook"
  end

  def search(query)
    solr = RSolr.connect :url => @solr_uri
    ret = {}
    begin
      ret = solr.get 'select', :params => {
                            :q => query,
                            :wt => "json" ## never use the @param_wt, the @param_wt will effect output only.
                          }
    rescue => ex
      puts ex.to_s
    end
    return ret
  end

  def add(document, update = false)
    require 'rsolr'
    ret = {}
    solr = RSolr.connect :url => @solr_uri
    begin
      puts document
      if update
        ret = solr.update(document)
      else
        ret = solr.add(document)
      end
      solr.commit
      ret = true
    rescue => ex
      puts ex.to_s
    end
    return ret
  end
end

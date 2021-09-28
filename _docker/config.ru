require 'bundler/setup'
Bundler.require

require './lib/mysolr'
require './lib/myutil'
require './lib/dataapi'
require './lib/deeplapi'
require './lib/gct'
require './lib/ats'

require './my_app'
run MyApp

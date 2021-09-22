require 'bundler/setup'
Bundler.require

require './lib/mysolr'
require './lib/myutil'
require './lib/dataapi'
require './lib/deeplapi'
require './lib/gct'

require './my_app'
run MyApp

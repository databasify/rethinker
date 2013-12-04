require 'rubygems'
require 'bundler'
Bundler.require

SPEC_ROOT = File.expand_path File.dirname(__FILE__)
Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |f| require f }

database_host = ENV['DB_HOST'] || 'localhost'
database_name = ENV['DB_NAME'] || 'rethinker_test'
Rethinker.connect "rethinkdb://#{database_host}/#{database_name}"

RSpec.configure do |config|
  config.color_enabled = true
  config.include ModelsHelper
  config.include CallbacksHelper

  config.before(:each) do
    Rethinker.purge!
  end

  config.after do
  end
end

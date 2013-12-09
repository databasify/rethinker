require 'rethinkdb'
require 'active_model'
require 'active_support/core_ext'

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('1.9')
  raise 'Please use Ruby 1.9 or later'
end

module Rethinker
  require 'rethinker/railtie' if defined?(Rails)
  require 'rethinker/autoload'
  extend Rethinker::Autoload

  autoload :Document, :EmbeddedDocument, :Connection, :Database, :Error, :QueryRunner, :Selection, :Relation, :Criterion
  require 'rethinker/document/dynamic_attributes'

  class << self
    # Note: we always access the connection explicitly, so that in the future,
    # we can refactor to return a connection depending on the context.
    # Note that a connection is tied to a database in Rethinker.
    attr_accessor :connection

    def connect(uri)
      self.connection = Connection.new(uri).tap { |c| c.connect }
    end

    delegate :db_create, :db_drop, :db_list, :database, :to => :connection
    delegate :table_create, :table_drop, :table_list,
             :purge!, :to => :database
    delegate :run, :to => QueryRunner

    def rails3?
      return @rails3 unless @rails3.nil?
      @rails3 = Gem.loaded_specs['activemodel'].version >= Gem::Version.new('3') &&
                Gem.loaded_specs['activemodel'].version <  Gem::Version.new('4')
    end
  end
end

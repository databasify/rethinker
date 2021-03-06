class Rethinker::Connection
  # A connection is bound to a specific database.

  attr_accessor :uri, :host, :port, :database_name

  def initialize(uri)
    self.uri = uri
    parse_uri
  end

  def raw
    @raw ||= RethinkDB::Connection.new(:host => host, :port => port, :db => database_name)
  end

  alias_method :connect, :raw
  delegate :reconnect, :close, :run, :to => :raw

  [:db_create, :db_drop, :db_list].each do |cmd|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{cmd}(*args)
        Rethinker.run { RethinkDB::RQL.new.#{cmd}(*args) }
      end
    RUBY
  end

  def database
    @database ||= Rethinker::Database.new(self)
  end

  private

  def parse_uri
    require 'uri'
    parsed_uri = URI.parse(uri)

    if parsed_uri.scheme != 'rethinkdb'
      raise Rethinker::Error::Connection,
        "Invalid URI. Expecting something like rethinkdb://host:port/database. Got #{uri}"
    end

    apply_connection_settings!(parsed_uri)
  end

  def apply_connection_settings!(uri)
    self.host = uri.host
    self.port = uri.port || 28015
    self.database_name = uri.path.gsub(/^\//, '')
  end
end

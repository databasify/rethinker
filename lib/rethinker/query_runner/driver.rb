class Rethinker::QueryRunner::Driver < Rethinker::QueryRunner::Middleware
  def call(env)
    # TODO have a logger
    puts env[:query].inspect if ENV['DEBUG']
    env[:query].run(Rethinker.connection, env[:options])
  rescue NoMethodError => e
    raise "Rethinker is not connected to a RethinkDB instance" unless Rethinker.connection
    raise e
  end
end

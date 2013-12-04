class Rethinker::QueryRunner::TableOnDemand < Rethinker::QueryRunner::Middleware
  def call(env)
    @runner.call(env)
  rescue RuntimeError => e
    if e.message =~ /^Table `(.+)` does not exist\.$/
      # TODO Lookup the Model, and get the primary key name
      Rethinker.table_create $1
      retry
    end
    raise e
  end
end

class Rethinker::QueryRunner::Selection < Rethinker::QueryRunner::Middleware
  def call(env)
    if env[:query].is_a? Rethinker::Selection
      env[:selection], env[:query] = env[:query], env[:query].query
    end
    @runner.call(env)
  end
end

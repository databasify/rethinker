require "rethinker"
require "rails"

class Rethinker::Railtie < Rails::Railtie
  config.action_dispatch.rescue_responses.merge!(
    "Rethinker::Errors::DocumentNotFound" => :not_found,
    "Rethinker::Errors::DocumentInvalid"  => :unprocessable_entity,
    "Rethinker::Errors::DocumentNotSaved" => :unprocessable_entity,
  )

  rake_tasks do
    load "rethinker/railtie/database.rake"
  end

  #config.eager_load_namespaces << Rethinker
end

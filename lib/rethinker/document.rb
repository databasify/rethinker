module Rethinker::Document
  extend ActiveSupport::Concern
  extend Rethinker::Autoload

  autoload_and_include :Core, :InjectionLayer, :Attributes, :Id, :Relation,
                       :Persistance, :Serialization, :Selection, :Validation, :Polymorphic,
                       :Timestamps
end

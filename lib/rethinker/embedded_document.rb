module Rethinker::EmbeddedDocument
  extend ActiveSupport::Concern

  include Rethinker::Document::Core
  include Rethinker::Document::InjectionLayer
  include Rethinker::Document::Attributes
  include Rethinker::Document::Id
  include Rethinker::Document::Relation
  include Rethinker::Document::Serialization
  include Rethinker::Document::Validation
  include Rethinker::Document::Polymorphic

  # TODO - this isn't correct
  delegate :new_record?, :persisted?, to: :parent    

end


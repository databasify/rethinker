module Rethinker::EmbeddedDocument
  extend ActiveSupport::Concern

  include Rethinker::Document::Core
  include Rethinker::Document::InjectionLayer
  include Rethinker::Document::Attributes
  include Rethinker::Document::Id
  include Rethinker::Document::Relation
  include Rethinker::Document::Validation

  delegate :new_record?, to: :parent

end

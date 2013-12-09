module Rethinker::Relation
  extend Rethinker::Autoload

  autoload :BelongsTo, :HasMany, :EmbedsMany, :EmbeddedIn
  # you also want to check Rethinker::Document::Relation
end

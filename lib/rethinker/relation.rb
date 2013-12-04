module Rethinker::Relation
  extend Rethinker::Autoload

  autoload :BelongsTo, :HasMany
  # you also want to check Rethinker::Document::Relation
end

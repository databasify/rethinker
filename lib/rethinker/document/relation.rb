module Rethinker::Document::Relation
  extend ActiveSupport::Concern

  included do
    class << self; attr_accessor :relations, :embedded_relations; end
    self.relations = {}
    self.embedded_relations = {}
  end

  def reset_attributes
    super
    @relations_cache = {}
    @embedded_relations_cache = {}
  end

  module ClassMethods
    def inherited(subclass)
      super
      subclass.relations = self.relations.dup
      subclass.embedded_relations = self.embedded_relations.dup
    end

    [:belongs_to, :has_many, :embeds_many, :embedded_in].each do |relation|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{relation}(target, options={})
          target = target.to_sym
          r = Rethinker::Relation::#{relation.to_s.camelize}.new(self, target, options)
          r.hook

          ([self] + descendants).each do |klass|
            klass.relations[target] = r
            #{"klass.embedded_relations[target] = r" if relation == :embeds_many}
          end
        end
      RUBY
    end
  end
end

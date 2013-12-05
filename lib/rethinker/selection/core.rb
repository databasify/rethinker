module Rethinker::Selection::Core
  extend ActiveSupport::Concern

  included do
    attr_accessor :context, :criteria
    delegate :inspect, to: :query
  end

  def initialize(criteria = [], context = {})
    # We are saving klass as a context
    # so that the table_on_demand middleware can do its job
    # TODO FIXME Sadly it gets funny with associations
    self.context = context
    self.criteria = [criteria].flatten
    self
  end

  def klass
    context[:klass]
  end

  def chain(criterion)
    self.criteria.concat([criterion]).flatten! unless criterion.blank?
    self
  end

  def run
    Rethinker.run { self.query }
  end

  def query
    chained_query = nil
    self.criteria.each do |criterion|
      chained_query = criterion.execute(chained_query, self.context)
    end
    chained_query
  end

end

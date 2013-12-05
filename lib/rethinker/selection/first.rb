module Rethinker::Selection::First
  def first
    self.context[:order] = :normal
    get_one
  end

  def last
    self.context[:order] = :reverse
    get_one
  end

  private

  def get_one
    klass.ensure_table! # needed as soon as we get a Query_Result
    order_by(:id) unless ordered?
    attrs = chain(Rethinker::Criterion.new(:limit, 1)).run.first
    klass.new_from_db(attrs)
  end
end

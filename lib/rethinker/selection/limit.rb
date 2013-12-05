module Rethinker::Selection::Limit
  # TODO Test these guys

  def limit(value)
    chain Rethinker::Criterion.new(:limit, value)
  end

  def skip(value)
    chain Rethinker::Criterion.new(:skip, value)
  end

  def [](sel)
    chain Rethinker::Criterion.new(:[], sel)
  end
end

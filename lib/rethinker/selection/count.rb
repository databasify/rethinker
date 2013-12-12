module Rethinker::Selection::Count
  def count
    chain(Rethinker::Criterion.new(:count)).run
  end

  def empty?
    count == 0
  end

  def any?
    !empty?
  end
  alias :exists? :any?

end

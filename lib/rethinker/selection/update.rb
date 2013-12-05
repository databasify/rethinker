module Rethinker::Selection::Update
  def update(attrs={}, &block)
    block = proc { attrs } unless block_given?
    chain(Rethinker::Criterion.new(:update, &block)).run
  end
end

module Rethinker::Selection::Get
  def get(id)
    chain Rethinker::Criterion.new(:get, id)
  end

end

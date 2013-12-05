module Rethinker::Selection::Delete
  def delete
    chain(Rethinker::Criterion.new(:delete)).run
  end

  def destroy
    each { |doc| doc.destroy }
  end
end

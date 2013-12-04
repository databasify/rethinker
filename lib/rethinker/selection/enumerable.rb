module Rethinker::Selection::Enumerable
  def each(&block)
    return enum_for(:each) unless block

    klass.ensure_table! # needed as soon as we get a Query_Result
    run.each do |attrs|
      yield klass.new_from_db(attrs)
    end
    self
  end

  # TODO test that
  def respond_to?(name, include_private = false)
    super || [].respond_to?(name)
  end

  # TODO Make something a bit more efficent ?
  def method_missing(name, *args, &block)
    return super unless [].respond_to?(name)
    each.__send__(name, *args, &block)
  end
end

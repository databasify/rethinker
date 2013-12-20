class Rethinker::Relation::EmbedsMany::Association
  attr_accessor :parent_instance, :relation
  delegate :foreign_key, :children_klass, to: :relation
  delegate :map, :empty?, :size, :count, :[], :first, :last, :*, :+, :-, :==,
           :at, :collect, :select, :reject, :detect, :each,
           to: :to_a

  def initialize(parent_instance, relation)
    self.relation = relation
    self.parent_instance = parent_instance
    self
  end

  def <<(child)
    # TODO raise when child doesn't have the proper type
    parent_instance.send("_#{relation.children_name}") << child
    child.parent = parent_instance
  end

  def new(attrs={})
    new_child = children_klass.new(attrs)
    new_child.parent = parent_instance
    #self << new_child
    new_child
  end
  alias_method :build, :new

  def to_a
    parent_instance.send("_#{relation.children_name}")
  end

end

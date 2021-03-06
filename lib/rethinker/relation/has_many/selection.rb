class Rethinker::Relation::HasMany::Selection < Rethinker::Selection
  attr_accessor :parent_instance, :relation
  delegate :foreign_key, :children_klass, :to => :relation

  def initialize(parent_instance, relation)
    self.relation = relation
    self.parent_instance = parent_instance
    super children_klass.with_table_name(relation.options[:table_name], parent_instance).where(foreign_key => parent_instance.id).criteria, klass: children_klass
  end

  def <<(child)
    # TODO raise when child doesn't have the proper type
    child.update_attributes(foreign_key => parent_instance.id)
  end

  def build(attrs={})
    children_klass.new(attrs.merge(foreign_key => parent_instance.id))
  end
  alias :new :build

  def create(*args)
    build(*args).tap { |doc| doc.save }
  end

  def create!(*args)
    build(*args).tap { |doc| doc.save! }
  end

  def find(id)
    where(id: id).first
  end

  def find!(id)
    find(id).tap do |doc|
      doc or raise Rethinker::Error::DocumentNotFound, "#{children_klass} id #{id} not found"
    end
  end

end

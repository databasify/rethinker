class Rethinker::Relation::EmbedsMany < Struct.new(:parent_klass, :children_name, :options)
  extend ActiveSupport::Autoload
  autoload :Association

  def children_klass
    # TODO test :class_name
    @children_klass ||= (options[:class_name] || children_name.to_s.singularize.camelize).constantize
  end

  def hook
    # TODO yell when some options are not recognized
    parent_klass.inject_in_layer :relations, <<-RUBY, __FILE__, __LINE__ + 1
      attr_accessor :_#{children_name}

      def #{children_name}=(new_children)
        @_#{children_name} = []
        new_children.each { |child| @_#{children_name} << child; child.parent = self; }
        @_#{children_name}
      end

      def #{children_name}
        # TODO Cache array
        relation = self.class.relations[:#{children_name}]
        @_#{children_name} ||= []
        ::Rethinker::Relation::EmbedsMany::Association.new(self, relation)
      end

      def #{children_name.to_s}_attributes
        @_#{children_name} ||= []
        @_#{children_name}.map{|child| child.attributes}
      end

      def #{children_name.to_s}_attributes=(new_attributes)
        if new_attributes
          self.#{children_name} = new_attributes.map{|child| #{children_klass.to_s}.new(child.merge(parent: self))}
        end
      end

    RUBY
  end
end

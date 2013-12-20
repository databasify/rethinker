class Rethinker::Relation::EmbeddedIn < Struct.new(:children_klass, :parent_name, :options)

  def parent_klass_lazy
    # TODO test :class_name
    @parent_klass_lazy ||= options[:class_name] || parent_name.to_s.camelize
  end

  def hook
    # TODO yell when some options are not recognized

    children_klass.inject_in_layer :relations, <<-RUBY, __FILE__, __LINE__ + 1

      attr_reader :#{parent_name.to_s}

      delegate :save, to: :parent

      def #{parent_name}=(new_parent)
        # If the child already has a parent, remove the child from it
        if @#{parent_name}
          @#{parent_name}.send("_#{children_klass.name.pluralize.underscore}").send("delete", self)
        end
        # Add the child to the new parent
        new_parent_children = new_parent.send("_#{children_klass.name.pluralize.underscore}")
        new_parent_children << self unless new_parent_children.include?(self)
        # Update the child's #parent link
        @#{parent_name} = new_parent
      end

      alias :parent :#{parent_name.to_s}
      alias :parent= :#{parent_name.to_s}=

      def siblings
        parent.send("#{children_klass.name.pluralize.underscore}")
      end

      # TODO Move these into an EmbeddedPersistence module

      def destroy
        parent.send("_#{children_klass.name.pluralize.underscore}").delete(self)
        save
      end

      def update_attributes(attrs, options={})
        assign_attributes(attrs, options)
        save
      end

    RUBY
  end
end

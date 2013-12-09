class Rethinker::Relation::EmbeddedIn < Struct.new(:children_klass, :parent_name, :options)

  def parent_klass_lazy
    # TODO test :class_name
    @parent_klass_lazy ||= options[:class_name] || parent_name.to_s.camelize
  end

  def hook
    # TODO yell when some options are not recognized

    children_klass.inject_in_layer :relations, <<-RUBY, __FILE__, __LINE__ + 1

      attr_accessor :#{parent_name.to_s}
      alias :parent :#{parent_name.to_s}
      alias :parent= :#{parent_name.to_s}=

    RUBY
  end
end

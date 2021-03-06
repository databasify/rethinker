module Rethinker::Document::Attributes
  extend ActiveSupport::Concern

  included do
    if Rethinker.rails3?
      include ActiveModel::MassAssignmentSecurity
    end
    #attr_accessor :attributes

    # Not using class_attribute because we want to
    # use our custom logic
    class << self; attr_accessor :fields; end
    self.fields = {}
  end

  def initialize(attrs={}, options={})
    super
    @attributes = {}
    assign_attributes(attrs, options.reverse_merge(:pristine => true))
  end

  def [](name)
    __send__("#{name}")
  end

  def []=(name, value)
    __send__("#{name}=", value)
  end

  def reset_attributes
    # XXX Performance optimization: we don't save field that are not
    # explicitly set. The row will therefore not contain nil for
    # unset attributes. This has some implication when using where()
    # see lib/rethinker/selection/where.rb
    self.attributes = {}

    # assign default attributes based on the field definitions
    self.class.fields.each do |name, options|
      self.__send__("#{name}=", options[:default]) if options.has_key?(:default)
    end
  end

  def assign_attributes(attrs, options={})
    reset_attributes if options[:pristine]

    # TODO Should we reject undeclared fields ?
    if options[:from_db]
      attributes.merge! attrs
    else
      if Rethinker.rails3?
        unless options[:without_protection]
          attrs = sanitize_for_mass_assignment(attrs, options[:as])
        end
      end
      attrs.each do |k,v| 
        if respond_to?("#{k}=")
          __send__("#{k}=", v) unless is_embedded_relation?(k)
        else 
          attributes[k.to_s] = v unless is_embedded_relation?(k)
        end
      end
    end

    # Handle embedded relations
    attrs.each do |k,v|
      if is_embedded_relation?(k)
        __send__("#{k.to_s}_attributes=", v)
      end
    end

  end
  alias_method :attributes=, :assign_attributes

  def is_embedded_relation?(relation_name)
    self.class.embedded_relations.has_key?(relation_name.to_sym)
  end

  def attributes
    embedded_attributes = {}
    self.class.embedded_relations.each do |name, relation|
      embedded_attributes[relation.children_name.to_s] = self.send("#{relation.children_name.to_s}_attributes")
    end
    @attributes.merge!(embedded_attributes)
  end

  # TODO test that thing
  def inspect
    attrs = self.class.fields.keys.map { |f| "#{f}: #{attributes[f.to_s].inspect}" }
    "#<#{self.class} #{attrs.join(', ')}>"
  end

  module ClassMethods
    def new_from_db(attrs, options={})
      klass_from_attrs(attrs).new(attrs, options.reverse_merge(:from_db => true)) if attrs
    end

    def inherited(subclass)
      super
      subclass.fields = self.fields.dup
    end

    def field(name, options={})
      name = name.to_sym

      # Using a hash because:
      # - at some point, we want to associate informations with a field (like the type)
      # - it gives us a set for free
      ([self] + descendants).each do |klass|
        klass.fields[name] ||= {}
        klass.fields[name].merge!(options)
      end

      # Using a layer so the user can use super when overriding these methods
      inject_in_layer :attributes, <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}=(value)
          attributes['#{name}'] = value
        end

        def #{name}
          attributes['#{name}']
        end
      RUBY
    end

    def remove_field(name)
      name = name.to_sym

      ([self] + descendants).each do |klass|
        klass.fields.delete(name)
      end

      inject_in_layer :attributes, <<-RUBY, __FILE__, __LINE__ + 1
        undef #{name}=
        undef #{name}
      RUBY
    end
  end
end

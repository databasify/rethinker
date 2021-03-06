module Rethinker::Document::Validation
  extend ActiveSupport::Concern
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  included do
    class << self
      def validates_associated(*associations)
        validates_with(AssociatedValidator, _merge_attributes(associations))
      end
    end
  end

  def save(options={})
    options = options.reverse_merge(:validate => true)

    if options[:validate]
      valid? ? super : false
    else
      super
    end
  end

  # TODO Test that thing
  def valid?(context=nil)
    super(context || (new_record? ? :create : :update))
  end

  [:save, :update_attributes].each do |method|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{method}!(*args)
        #{method}(*args) or raise Rethinker::Error::DocumentInvalid, errors
      end

    RUBY
  end

  class UniquenessValidator < ActiveModel::EachValidator
    # Validate the document for uniqueness violations.
    #
    # @example Validate the document.
    #   validate_each(person, :title, "Sir")
    #
    # @param [ Document ] document The document to validate.
    # @param [ Symbol ] attribute The field to validate on.
    # @param [ Object ] value The value of the field.
    #
    # @return [ Boolean ] true if the attribute is unique.
    def validate_each(document, attribute, value)
      is_unique = if document.embedded?
        check_embedded_uniqueness(document, attribute, value)
      else
        check_uniqueness(document, attribute, value)
      end
      document.errors.add(attribute, 'is already taken') unless is_unique
      is_unique
    end

    def check_uniqueness(document, attribute, value)
      finder = document.root_class.where(attribute => value)
      finder = apply_scopes(finder, document)
      finder = exclude_document(finder, document) if document.persisted?
      finder.count == 0
    end

    def check_embedded_uniqueness(document, attribute, value)
      found = document.siblings.select{|sibling| sibling.attributes[attribute.to_s] == value}
      Array.wrap(options[:scope]).each do |scope_item|
        found = found.select{|sibling| sibling.attributes[scope_item.to_s] == document.attributes[scope_item.to_s]}
      end
      found.reject{|sibling| sibling == document}.count == 0
    end

    def apply_scopes(finder, document)
      Array.wrap(options[:scope]).each do |scope_item|
        finder = finder.where{|doc| doc[scope_item.to_s].eq(document.attributes[scope_item.to_s])}
      end
      finder
    end

    def exclude_document(finder, document)
      finder.where{|doc| doc["id"].ne(document.attributes["id"])}
    end
  end

  class AssociatedValidator < ActiveModel::EachValidator
    def validate_each(document, attribute, value)
      valid = Array.wrap(value.to_a).collect do |doc|
        if doc.nil?
          true
        else
          doc.valid?
        end
      end.all?
      document.errors.add(attribute, :invalid, options) unless valid
    end
  end
end

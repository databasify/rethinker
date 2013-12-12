module ModelsHelper
  def load_simple_document
    define_constant :SimpleDocument do
      include Rethinker::Document

      field :field1
      field :field2
      field :field3
    end
  end

  def load_blog_models
    define_constant :Post do
      include Rethinker::Document

      field :title
      field :body

      has_many :comments
    end

    define_constant :Comment do
      include Rethinker::Document

      field :author
      field :body

      belongs_to :post
    end
  end

  def load_embedded_models
    define_constant :ApiKey do
      include Rethinker::EmbeddedDocument
      embedded_in :account

      def raise_error
        raise StandardError
      end

      field :key
    end

    define_constant :Account do
      include Rethinker::Document
      embeds_many :api_keys
      validates_associated :api_keys

      field :name
    end
  end

  def load_polymorphic_models
    define_constant :Parent do
      include Rethinker::Document
      field :parent_field
    end

    define_constant :Child, Parent do
      field :child_field
    end

    define_constant :GrandChild, Child do
      field :grand_child_field
    end
  end
end

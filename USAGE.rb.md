# Rethinker
## A Ruby ORM for RethinkDB

**Source:** [github.com/databasify/rethinker](https://github.com/databasify/rethinker)

<small>Based on [NoBrainer](https://github.com/nviennot/nobrainer)</small>

    .

Connect to RethinkDB.  
Connection string takes the form `rethinkdb://<hostname>/<database>`.  
Currently, Rethinker only supports a single database.  
In a Rails project, `config/initializers/rethinker.rb` would be a good place for this.

    Rethinker.connect 'rethinkdb://localhost/blog'








    class Post
To use Rethinker with a model, include `Rethinker::Document`.
      include Rethinker::Document

Specify field names, optionally providing a default value.

      field :title, default: "Untitled"
      field :body
      field :slug

Rethinker currently supports only `has_many`/`belongs_to` relationships.

      has_many :comments

Rethinker supports all of the [validations from Active Model](http://api.rubyonrails.org/classes/ActiveModel/Validations.html).
      validates :body, presence: true
      validates :title, presence: true, length: {minimum: 5, maximum: 250}
      validates :slug, uniqueness: true
    end

    class Comment
      include Rethinker::Document
You can enable the persistence of dynamic attributes by also including `Rethinker::Document::DynamicAttributes`. See below for an example.
      include Rethinker::Document::DynamicAttributes

      field :author
      field :body

      belongs_to :post

      validates :author, :body, :post, :presence => true

When using a `uniqueness` validation with one or more scopes, and referencing an association, use the association's foreign key, e.g. `post_id`, and not the association name, e.g. `post`
      validates :body, uniqueness: {scope: :post_id}

      after_create do
        puts "#{author} commented on #{post.title}"
      end
    end
        


You can clear all data in the database by truncating all tables...


    
    Rethinker.purge!

... or optionally dropping the whole database.
    Rethinker.purge!(drop: true)

Prefer `Model.create!` to `Model.create`, because `create!` will raise an exception if validations fail, whereas `create` will simply return an unsaved model object.
    post = Post.create!(:title => 'ohai', :body  => 'yummy')

    puts post.comments.create(:author => 'dude').
      errors.full_messages == ["Body can't be blank"]

    post.comments.create(:author => 'dude', :body => 'burp')
    post.comments.create(:author => 'dude', :body => 'wut')
    post.comments.create(:author => 'joe',  :body => 'sir')
    Comment.all.each { |comment| puts comment.body }

    post.comments.where(:author => 'dude').destroy
    puts post.comments.count == 1

Because we included `Rethinker::Document::DynamicAttributes` in the `Comment` class, we can access and update fields not defined using `field`.

Note that setters and getters are *not* created, so you need to access dynamic fields through `object['fieldname']`.

    comment = post.comments.first
    comment['author_status'] = 'Space Cadet'
    comment.save

    post.comments.first['author_status']
     => 'Space Cadet'


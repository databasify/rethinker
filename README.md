Rethinker
===========

Rethinker is a Ruby ORM for [RethinkDB](http://www.rethinkdb.com/).

Installation
-------------

```ruby
gem 'rethinker'
```

Usage
------

Here is a quick example of what Rethinker can do:

```ruby
require 'rethinker'

Rethinker.connect 'rethinkdb://localhost/blog'

class Post
  include Rethinker::Document

  field :title
  field :body

  has_many :comments

  validates :title, :body, :presence => true
end

class Comment
  include Rethinker::Document

  field :author
  field :body

  belongs_to :post

  validates :author, :body, :post, :presence => true

  after_create do
    puts "#{author} commented on #{post.title}"
  end
end

Rethinker.purge!

post = Post.create!(:title => 'ohai', :body  => 'yummy')

puts post.comments.create(:author => 'dude').
  errors.full_messages == ["Body can't be blank"]

post.comments.create(:author => 'dude', :body => 'burp')
post.comments.create(:author => 'dude', :body => 'wut')
post.comments.create(:author => 'joe',  :body => 'sir')
Comment.all.each { |comment| puts comment.body }

post.comments.where(:author => 'dude').destroy
puts post.comments.count == 1

# Handles Regex as a condition
post.comments.create(:author => 'dude', :body => 'hello')
post.comments.create(:author => 'dude', :body => 'ohai')

post.comments.where(:body => /^h/).map{|comment| comment.body } # => ["hello"]
post.comments.where(:body => /h/).map{|comment| comment.body } # => ["ohai", "hello"]
```

Features
---------

* Compatible with Rails 3 and Rails 4
* Autogeneration of ID, MongoDB style
* Creation of database and tables on demand
* Attributes accessors (`attr_accessor`)
* Dynamic attributes
* Validation support, expected behavior with `save!`, `save`, etc. (uniqueness validation still in development)
* Validatation with create, update, save, and destroy callbacks.
* `find`, `create`, `save`, `update_attributes`, `destroy` (`*.find` vs. `find!`).
* `where`, `order_by`, `skip`, `limit`, `each`
* `update`, `inc`, `dec`
* `belongs_to`, `has_many`
* `to_json`, `to_xml`
* `attr_protected`
* Scopes
* Thread-safe
* Polymorphism

Contributors
------------
- Andy Selvig (@ajselvig)

License
--------

Copyright © 2013 Databasify

Rethinker is a fork of NoBrainer 
Copyright © 2012 Nicolas Viennot

See [`LICENSE.md`](https://github.com/databasify/rethinker/blob/master/LICENSE.md).

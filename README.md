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

[See documentation](http://databasify.github.io/rethinker)

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

Rethinker is a fork of NoBrainer, copyright © 2012 Nicolas Viennot

See [`LICENSE.md`](https://github.com/databasify/rethinker/blob/master/LICENSE.md).

# permissionable
## Installation

Permissionable is distributed as a gem. To install, just add this line to your Gemfile:  
`gem 'permissionable', '~> 0.1.1'`


## Usage
### Hooking up your model with permissionable super powers
Hooking up your model is as easy as including `Permissionable` and defining your permission **schema**
```
include Permissionable
permissions read: 1,
            write: 2,
            delete: 3
```

Your model doesn't have to be an ActiveRecord (AR) model, but Permissionable works out of the box with AR to persist the permissions. Just throw in a `permissions` column in the mix.
```
class AddPermissionsToResource < ActiveRecord::Migration
  def change
    add_column :resources, :permissions, :integer
  end
end
```

If your're not using AR can also implement your own `#read_attribute` and `#update_column` methods to handle `read_attribute(:permissions)` and `update_column(:permissions, permissions_integer)`

### Working with permissions
#### Check for permissions
To check if your permissionable resource has a certain permission, use the [] method which will return true or false.

For instance, to check if your user has permission to :read_books,   
`user.permissions[:read_books]`

You can also specify multiple permissions, which will check to see if your resource has all of the permissions provided (I.e. it will return false if any of the permissions are missing).  
`user.permissions[:read_books, :delete_books]`

**Note** if you find the permissions[:read_books, :delete_books] syntax awkward, you can also use #include?  
`user.permissions.include?(:read_books, :delete_books)`

#### Add permissions
You can add permissions to your resource with the familiar "append to"-syntax. To add permissions to :read_books to your user:  
`user.permissions << :read_books`

You can also add an array of permissions yo your array of permissions:  
`user.permissions << [:read_books, :delete_books]`

**Note** Again, if special syntax like this isn't really your cup of tea, you can also use #add  
`user.permissions.add(:read_books, :delete_books)`

#### Remove permissions
Removing permissions from your resource is pretty straight forward:  
`user.permissions.remove(:delete_books)`

### Examples
```
class User < ActiveRecord::Base
  include Permissionable
  
  permissions read: 1,
              write: 2,
              delete: 3
end
```

```
user = User.create
user.permissions[:read] # => false
user.permissions << :read
user.permissions[:read] # => true
user.permissions[:read, :write] # => false
user.permissions << :write
user.permissions[:read, :write] # => true
user.permissions.remove(:read)
user.permissions[:read, :write] # => false
```

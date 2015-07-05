# permissionable
## Installation
TODO

## Usage
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

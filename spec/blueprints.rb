require 'machinist/active_record'
require 'sham'
require 'faker'

User.blueprint do
  email       { Faker::Internet.email   }
  first_name  { Faker::Name.first_name  }
  last_name   { Faker::Name.last_name   }
end

require 'machinist/active_record'
require 'sham'
require 'faker'
require 'uuidtools'

User.blueprint do
  email           { Faker::Internet.email   }
  first_name      { Faker::Name.first_name  }
  last_name       { Faker::Name.last_name   }
  activation_tag  { UUIDTools::UUID.timestamp_create().to_s }
end

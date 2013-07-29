require 'test/unit'
require 'active_record'

require 'transitions'
require 'active_model/transitions'

require 'mocha'
require 'random_data'

def db_defaults!
  ActiveRecord::Base.establish_connection(:adapter  => 'mysql2', :host => 'localhost', :user => 'root')
  ActiveRecord::Base.connection.drop_database 'transitions_test' rescue nil
  ActiveRecord::Base.connection.create_database 'transitions_test'
  ActiveRecord::Base.establish_connection(:adapter  => 'mysql2', :database => 'transitions_test')
  ActiveRecord::Migration.verbose = false
end

def set_up_db(*migrations)
  db_defaults!
  migrations.each { |klass| klass.send :migrate, :up }
end

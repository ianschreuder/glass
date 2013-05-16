SEED_WIPE_TABLES = %w( 
      users
      login_actions
  )
SEED_WIPE_TABLES.each do |table|
  ActiveRecord::Base.connection.execute("delete from #{table}")
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table}_id_seq RESTART WITH 1;") unless ["friendships", "games_users"].include?(table)
end



class CreateBase < ActiveRecord::Migration

  def change

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    create_table :users do |t|
      t.string    :name, :limit => 200
      t.string    :email
      t.string    :password_digest, :limit => 100
      t.integer   :registered, :limit=>1, :default=>0
      t.integer   :admin, :limit => 1, :default => 0
      t.datetime  :deleted_at
      t.string    :time_zone, :limit=>100
      t.timestamps
    end

    create_table :locations do |t|
      t.integer :user_id
      t.float :lat
      t.float :lng
    end

    create_table :logins do |t|
      t.integer :user_id
      t.string :user_agent, :limit=>500
      t.string :remote_addr, :limit => 50
      t.string :referer, :limit=>500
      t.integer :status
      t.timestamps
    end

    create_table :login_actions do |t|
      t.integer :user_id
      t.integer :login_id
      t.string :uri, :limit => 500
      t.string :details, :limit => 1000
      t.datetime :created_at
    end
    
    add_index :sessions, :session_id

    # execute static sql
    files = []
    files.each do |str|
      File.open("#{Rails.root}/db/static/#{str}","r") do |file|
        file.each_line do |line|
          begin
            ActiveRecord::Base.connection.execute(line)
          rescue Exception => e
            p e
          end
        end
      end
    end

  end

end


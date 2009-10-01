class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
    end

    # generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"

    create_role("admin")
    create_role("patient")
    create_role("doctor")

    create_user_in_role ("admin", "admin@localhost.com", "password", "admin", "Adam")  
    create_user_in_role ("pacjent", "pacjent@localhost.com", "pacjent", "patient", "Pat")  
    create_user_in_role ("doctor1", "doctor@localhost.com", "doctor1", "doctor", "Dr Doc")  
    create_user_in_role ("doctor2", "doctor@localhost.com", "doctor2", "doctor", "Jakyll")  

  end

  

  def self.down

    admin_user = User.find_by_login("admin")
    admin_role = Role.find_by_name("admin")
    admin_user.roles = []
    admin_user.save
    admin_user.destroy
    admin_role.destroy

    drop_table "roles"
    drop_table "roles_users"
  end


private
  
  def self.create_role (role_name)
    role = Role.new
    role.name = role_name
    role.save
  end

  def self.create_user_in_role (login, email, password, role_name, name)

    user = User.new
    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password
    user.name = name
    user.save(false)
    
    
    user = User.find_by_login(login)
    role = Role.find_by_name(role_name)
    user.activate!

    user.roles << role
    user.save(false)		

  end

end


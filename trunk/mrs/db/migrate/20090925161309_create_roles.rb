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
  

end


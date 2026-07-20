class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false

    reversible do |dir|
      dir.up do
        User.where(username: "admin").update_all(admin: true)
      end
    end
  end
end

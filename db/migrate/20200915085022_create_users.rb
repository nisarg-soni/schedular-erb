class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :role
      t.string :name
      t.boolean :has_resume

      t.timestamps
    end
  end
end

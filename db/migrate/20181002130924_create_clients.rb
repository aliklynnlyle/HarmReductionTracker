class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :city
      t.string :county
      t.boolean :first_kit
      t.integer :client_confidential_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

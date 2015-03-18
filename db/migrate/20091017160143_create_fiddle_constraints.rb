class CreateFiddleConstraints < ActiveRecord::Migration
  def change
    create_table :fiddle_constraints do |t|
      t.string  :name, :limit => 30
      t.integer :cube_id
      t.integer :projection_id
      t.string  :operation_code, :limit => 20
      t.timestamps null: true
    end
    add_index :fiddle_constraints, :cube_id
    add_index :fiddle_constraints, :projection_id
  end
end

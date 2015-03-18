class CreateFiddleProjections < ActiveRecord::Migration
  def change
    create_table :fiddle_projections do |t|
      t.string  :name, :limit => 80
      t.string  :type, :limit => 30
      t.string  :clause
      t.boolean :sortable, :null => false, :default => false
      t.boolean :visible, :null => false, :default => true
      t.string  :type_code, :limit => 20
      t.integer :cube_id
      t.timestamps null: true
    end
    add_index :fiddle_projections, :type
    add_index :fiddle_projections, :cube_id
  end
end

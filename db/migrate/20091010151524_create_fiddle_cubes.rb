class CreateFiddleCubes < ActiveRecord::Migration
  def change
    create_table :fiddle_cubes do |t|
      t.string  :name, :limit => 80
      t.text    :clause
      t.integer :universe_id
      t.timestamps
    end
    add_index :fiddle_cubes, :universe_id
  end
end

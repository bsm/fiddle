class CreateFiddleLookups < ActiveRecord::Migration
  def change
    create_table :fiddle_lookups do |t|
      t.string  :name, :limit => 30
      t.integer :cube_id
      t.text    :clause
      t.string  :label_clause, :limit => 255
      t.string  :value_clause, :limit => 255
      t.timestamps
    end
  end
end

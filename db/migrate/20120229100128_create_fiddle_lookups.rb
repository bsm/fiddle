class CreateFiddleLookups < ActiveRecord::Migration
  def change
    create_table :fiddle_lookups do |t|
      t.string  :name, :limit => 30
      t.integer :universe_id
      t.text    :clause
      t.string  :label_clause, :limit => 255
      t.string  :value_clause, :limit => 255
      t.timestamps null: true
    end
    add_index :fiddle_lookups, :universe_id
  end
end

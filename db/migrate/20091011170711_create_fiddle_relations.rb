class CreateFiddleRelations < ActiveRecord::Migration
  def change
    create_table :fiddle_relations do |t|
      t.string  :name, :limit => 80
      t.string  :operator, :limit => 30
      t.text    :target
      t.text    :predicate
      t.integer :cube_id
      t.timestamps null: true
    end
    add_index :fiddle_relations, :cube_id
    add_index :fiddle_relations, :name
  end
end

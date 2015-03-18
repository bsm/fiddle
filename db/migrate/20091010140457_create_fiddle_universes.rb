class CreateFiddleUniverses < ActiveRecord::Migration
  def change
    create_table :fiddle_universes do |t|
      t.string :name
      t.string :uri
      t.timestamps null: true
    end
  end
end

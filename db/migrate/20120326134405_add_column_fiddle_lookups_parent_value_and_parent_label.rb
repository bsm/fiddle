class AddColumnFiddleLookupsParentValueAndParentLabel < ActiveRecord::Migration
  def change
    add_column :fiddle_lookups, :parent_value_clause, :string, :limit => 255
    add_column :fiddle_lookups, :parent_label_clause, :string, :limit => 255
  end
end

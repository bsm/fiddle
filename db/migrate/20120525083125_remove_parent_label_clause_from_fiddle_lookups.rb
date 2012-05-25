class RemoveParentLabelClauseFromFiddleLookups < ActiveRecord::Migration
  def change
    remove_column :fiddle_lookups, :parent_label_clause
  end
end

class AddDescriptionsToProjections < ActiveRecord::Migration
  def change
    add_column :fiddle_projections, :description, :string, :limit => 80
  end
end

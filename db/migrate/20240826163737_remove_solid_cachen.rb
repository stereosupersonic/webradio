class RemoveSolidCachen < ActiveRecord::Migration[7.2]
  def change
    drop_table :solid_cache_entries
  end
end

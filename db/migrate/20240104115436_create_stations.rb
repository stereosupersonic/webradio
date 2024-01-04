class CreateStations < ActiveRecord::Migration[7.1]
  def change
    create_table :stations do |t|
      t.string :name
      t.text :url
      t.integer :position, default: 100, index: true

      t.timestamps
    end
  end
end

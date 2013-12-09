class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :full_street_address
      t.integer :movie_id

      t.timestamps
    end
  end
end

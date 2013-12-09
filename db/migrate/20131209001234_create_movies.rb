class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :fun_fact
      t.integer :producer_id
      t.integer :director_id
      t.string :imdb_id
      t.string :imdb_rating
      t.string :poster_url
      t.text :plot
      t.string :actors, array: true, default: []

      t.timestamps
    end
  end
end

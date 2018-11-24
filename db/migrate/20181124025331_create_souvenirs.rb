class CreateSouvenirs < ActiveRecord::Migration[5.2]
  def change
    create_table :souvenirs do |t|
      t.string :name
      t.string :source
      t.string :description
      t.integer :year_obtained
      t.integer :user_id
    end
  end
end

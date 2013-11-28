class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :source, :default=>"email"
      t.string :location, :default=>"Default Location"
      t.integer :e_sents
      t.integer :e_oppened
      t.integer :e_views
      t.integer :e_converted
      t.integer :user_id
      t.timestamps
    end
  end
end

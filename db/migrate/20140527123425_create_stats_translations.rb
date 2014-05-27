class CreateStatsTranslations < ActiveRecord::Migration
  def change
    create_table :stats_translations do |t|

      t.timestamps
    end
  end
end

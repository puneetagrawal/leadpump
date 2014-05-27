class CreatePlanTranslations < ActiveRecord::Migration
  def change
    create_table :plan_translations do |t|

      t.timestamps
    end
  end
end

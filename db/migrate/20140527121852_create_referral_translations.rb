class CreateReferralTranslations < ActiveRecord::Migration
  def change
    create_table :referral_translations do |t|

      t.timestamps
    end
  end
end

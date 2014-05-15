class AddAgeIsMemberCurrentlyExerciseProgramSpanToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :age, :integer
    add_column :leads, :is_member, :boolean
    add_column :leads, :currently_exercise, :string
    add_column :leads, :program_span, :string
  end
end

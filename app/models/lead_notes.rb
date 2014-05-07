class LeadNotes < ActiveRecord::Base
  attr_accessible :lead_id, :notes, :time_stam
  belongs_to :lead

  default_scope { order("created_at DESC") }
end

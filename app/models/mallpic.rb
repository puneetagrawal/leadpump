class Mallpic < ActiveRecord::Base
  attr_accessible :onlinemall_id, :avatar

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "30x30>" }, :default_url => "/images/:style/missing.png"
  belongs_to :onlinemall

  validates :avatar, :presence => true
  validate :file_dimensions

  private

  def file_dimensions(width = 300, height = 300)
    dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
    unless dimensions.width == width && dimensions.height == height
      errors.add :avatar, "Width must be #{width}px and height must be #{height}px"
    end
  end
end

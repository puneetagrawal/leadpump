class Onlinemall < ActiveRecord::Base
  attr_accessible :active, :link, :mallpic_id, :title, :user_id, :description, :file

  translates :title, :description

  has_many :mallpic
  belongs_to :user
  has_attached_file :file, :styles => { :medium => "100x100>", :thumb => "30x30>" }, :default_url => "/images/:style/missing.png"
  
  accepts_nested_attributes_for :mallpic

  validates :title, :presence => true
  validates :file, :presence => true
  #validates :link, :presence => true

	def to_html
		Renderer::render_view('vipleads/download.html.erb', {mall: self}, {layout: false})
	end

  def createpdf
  	WickedPdf.new.pdf_from_string(
	  render_to_string('vipleads/viewMallItem.html.erb')
	)
  end
end

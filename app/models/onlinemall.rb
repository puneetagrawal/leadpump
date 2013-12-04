class Onlinemall < ActiveRecord::Base
  attr_accessible :active, :link, :mallpic_id, :title, :user_id

  has_many :mallpic
  belongs_to :user

  accepts_nested_attributes_for :mallpic

  validates :title, :presence => true
  validates :link, :presence => true

	def to_html
		Renderer::render_view('vipleads/download.html.erb', {mall: self}, {layout: false})
	end

  def createpdf
  	WickedPdf.new.pdf_from_string(
	  render_to_string('vipleads/viewMallItem.html.erb')
	)
  end
end

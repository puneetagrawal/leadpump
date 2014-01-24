module OnlinemallHelper

	def fetchcheckbox(om,user)
		checkbox = ''
		if user.role.id == 2
			id = om.id
			checkbox = "<%=check_box_tag 'onlinemall_#{id}', 'yes', false, :class => 'mall_chek'%>"
			companymallitem = Companymallitem.where(:user_id=>user.id, :onlinemall_id=>id)
			if companymallitem.present?
				checkbox = "<%=check_box_tag 'onlinemall_#{id}', 'yes', true, :class => 'mall_chek'%>"
			end
		end
		return render(:inline=> checkbox)
	end

	def fetchAssociate(om)
		name = 'Admin'
		if om.user.role.id == 2 
			name = om.user.name.humanize
		end
		return name		
	end

	def fetchlandpageheadimage(landpage)
		if landpage.present?
			if landpage.temp_name == "Guest pass card"
				img = '<img src="/assets/land_page/template4.png">'
			elsif landpage.temp_name == "Woman doing aerobics"
				img = '<img src="/assets/land_page/women.png">'
			elsif landpage.temp_name == "Membership card"
				img = '<img src="/assets/land_page/template3.png">'
			elsif landpage.temp_name == "Personal trainer"
				img = '<img src="/assets/land_page/template2.png">'
			end
		else
			img = '<img src="/assets/land_page/template2.png">'
		end
		# if landpage.present?
		# 	img = image_tag landpage.land_page_logos[0].avatar.url(:medium), :class=>"img-polaroid" 
		# end
		return img.html_safe
	end
	def fetchlandpreivewimage(landpage)
		img = '<img src="/assets/land_page/women.png">'
		# if landpage.present? && landpage.avatar.present?
		# 	img = image_tag landpage.avatar.url(:medium), :class=>"img-polaroid" 
		# end
		return img.html_safe
	end

	def fetchCompanyLogo(company)
    img = '<img src="images/gymslogo.png" style="max-width:250px;max-height:100px;"/>'
    if company.picture.present?
      img = image_tag company.picture.avatar.url(), :class=>'img-polaroid mh60 logo_dimension'
    end
    return img.html_safe
  end 

  def getsubstring(title)
  	logger.debug(title.length)
  	title = title.present? ? title.length > 9 ? "#{title[0..7]}.." : title : ''
  	return title
  end

end

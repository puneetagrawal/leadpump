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
		img = '<img src="/assets/land_page/women.png">'
		if landpage.present?
			img = image_tag landpage.land_page_logos[0].avatar.url(), :class=>"img-polaroid" 
		end
		return img.html_safe
	end

	def fetchlandpreivewimage(landpage)
		img = '<img src="/assets/land_page/women.png">'
		if landpage.present? && landpage.avatar.present?
			img = image_tag landpage.avatar.url(), :class=>"img-polaroid" 
		end
		return img.html_safe
	end

	def fetchCompanyLogo(company)
    img = '<img src="images/gymslogo.png"/>'
    if company.picture.present?
      img = image_tag company.picture.avatar.url(:medium), :class=>'img-polaroid'
    end
    return img.html_safe
  end 

end

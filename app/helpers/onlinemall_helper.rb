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

end

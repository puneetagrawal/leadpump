class SaleProd < ActiveRecord::Base
  attr_accessible :appointment, :call, :mail, :net, :referral, :user_id
  has_many :sale_reports
  belongs_to :user

  #accepts_nested_attributes_for :sale_reports

  def self.fetchProdDataUpToDate(user, date)
  	to_date = SaleProd.fetchToDate(date)
  	if user.isAdmin
  		prod = SaleProd.includes(:sale_reports).where("created_at >= ? and created_at < ?",to_date, date+1)
  	elsif user.isCompany
      users = user.fetchCompanySalesUsers
      users = users.collect{|user| user.id}
      users << user.id
      prod = SaleProd.includes(:sale_reports).where("created_at >= ? and created_at < ?",to_date, date+1).where(:user_id=>users)
    else
      prod = SaleProd.includes(:sale_reports).where("created_at >= ? and created_at < ?", to_date, date+1).where(:user_id=>user)
    end
  	return prod
  end

  def self.fetchProdDataToDay(user, date)
  	if user.isAdmin
  		prod = SaleProd.where("created_at = ?", date)
    elsif user.isCompany
      users = user.fetchCompanySalesUsers
      users = users.collect{|user| user.id}
      users << user.id
      prod = SaleProd.includes(:sale_reports).where("created_at >= ? and created_at < ?",date, date+1).where(:user_id=>users)
    else
      prod = SaleProd.includes(:sale_reports).where("created_at >= ? and created_at < ?", date, date+1).where(:user_id=>user)
    end
  	return prod
  end

  # def self.fetchProdDataTotal(user)
  #   if user.isAdmin
  #     prod = SaleProd.includes(:sale_reports).where("created_at < ?", Date.today+1)
  #   elsif user.isCompany
  #     users = user.fetchCompanySalesUsers
  #     users = users.collect{|user| user.id}
  #     users << user.id
  #     prod = SaleProd.includes(:sale_reports).where("created_at < ?",Date.today+1).where(:user_id=>users)
  #   else
  #     prod = SaleProd.includes(:sale_reports).where("created_at < ?",Date.today+1).where(:user_id=>user)
  #   end
  #   return prod
  # end
  
  def self.fetchGrossPaper(sale_todate, sale_tody)
  	grossmaptody = SaleProd.fetchGrossMap(sale_tody)
  	grossmaptodate = SaleProd.fetchGrossMap(sale_todate)
  	return {:g_todate=>grossmaptodate,:g_tody=>grossmaptody}
  end

  def self.fetchgrossvalue(list)
  	return list.inject(0, :+)
  end

  def self.fetchGrossMap(sale)
  	g_gross = 0
  	g_cash = 0
  	g_eft = 0
    g_mem = 0
    call = 0
    mail = 0
    net = 0
    total = 0
    appointment = 0
  	if !sale.blank? && sale.present?
  		sale.each do |s_tdt|
  			if s_tdt.sale_reports.present?
  				g_cash += SaleProd.fetchgrossvalue(s_tdt.sale_reports.collect{|sale| sale.amount}.compact)
  				g_eft += SaleProd.fetchgrossvalue(s_tdt.sale_reports.collect{|sale| sale.eft}.compact)
          g_gross += SaleProd.fetchgrossvalue(s_tdt.sale_reports.collect{|sale| sale.contract}.compact)
          g_mem += s_tdt.sale_reports.size
          call += s_tdt.call ? s_tdt.call : 0
          mail += s_tdt.mail ? s_tdt.mail : 0
          net +=  s_tdt.net ? s_tdt.net : 0
  			end
  		end
  	end
    m_avg = SaleProd.fetchAvg(g_mem)
  	c_avg = SaleProd.fetchAvg(g_cash)
  	e_avg = SaleProd.fetchAvg(g_eft)
    g_avg = SaleProd.fetchAvg(g_gross)
    
    g_prjt = SaleProd.fetchProjection(g_avg)
  	c_prjt = SaleProd.fetchProjection(c_avg)
  	e_prjt = SaleProd.fetchProjection(e_avg)
    m_prjt = SaleProd.fetchProjection(m_avg)

    total = net + mail + call + g_mem
  	return {:g_cash=>g_cash,:g_mem=>g_mem,:g_eft=>g_eft,:g_gross=>g_gross,:c_avg=>c_avg,:e_avg=>e_avg,:m_avg=>m_avg,
      :g_avg=>g_avg,:c_prjt=>c_prjt,:e_prjt=>e_prjt,:g_prjt=>g_prjt, :m_prjt=>m_prjt,:call=>call,
      :mail=>mail,:net=>net,:total=>total}
  end

  def self.fetchAppointment(date, user)
    users = User.fetchCompanyUserList(user)
    users << user
    users = users.uniq
    to_date = SaleProd.fetchToDate(date)
    to_dt_app = Appointment.where("updated_at >= ? and updated_at < ?", to_date, date+1).where(:user_id=>users).count
    tod_app = Appointment.where("updated_at >= ? and updated_at < ?", date, date+1).where(:user_id=>users).count
    return {:today_app=>tod_app, :to_dt_app=>to_dt_app}
  end

  def self.fetchToDate(date)
  	return date.at_beginning_of_month - 1
  end

  def self.fetchAvg(amount)
  	avg =  (amount.to_f/Date.today.day).round(2)
  end

  def self.fetchProjection(amount)
  	return (Date.today.end_of_month.day * amount).round(2)
  end
  
end

class UserMailer < ActionMailer::Base
  default :from => "dvporg@gmail.com"
  
  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription suspended")
  end

  def attach_user(user,current_user,comment = "")
  	@user = user
  	@current_user = current_user
  	@comment = comment
  	mail(:to => user.email, :subject => "You have been registered at Includes.io by #{@current_user.name}")
  end

  def send_alert(email,text)
    @text = text
    mail(:to => email, :subject => "You includes are suspended")
  end
end
class PasswordController < ApplicationController

  # generates password and slides open password suggestion
  def new
    ps = PasswordService.generate_password
    html = "Husk: #{ps[:password]}"

    render :update do |page|
      page.show 'new_password'
      page.replace_html 'new_password', html
      page.show 'change_password' if current_user.status == 'new_password'
      page['password'].value = ps[:password]
      page['password_confirmation'].value = ps[:password]
      # page.password.value = ps[:password]
      page.visual_effect :pulsate, 'new_password', :duration => 1
      page.visual_effect :highlight, 'password', :duration => 2
      page.visual_effect :highlight, 'password_confirmation', :duration => 2
    end
  end

end
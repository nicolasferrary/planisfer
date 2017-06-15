class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  def facebook
    puts
    @member = Member.from_omniauth(request.env['omniauth.auth'])
    puts
    if @member.persisted?
      puts
      sign_in_and_redirect @member, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      puts
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_member_session_path
    end
  end

  def failure
    puts
    redirect_to new_member_session_path
  end

end

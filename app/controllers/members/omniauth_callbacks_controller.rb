class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  def facebook

    @member = Member.from_omniauth(request.env['omniauth.auth'])
    if @member.persisted?
      sign_in_and_redirect @member, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_member_session_path
    end
  end

  # def failure
  #   redirect_to new_member_registration_path
  # end

end

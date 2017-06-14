class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  def facebook

    @member = Member.from_omniauth(request.env['omniauth.auth'])
    # if @member.nil?
    #   redirect_to new_member_session_path
    if @member.persisted?
      puts 'persisted'
      sign_in_and_redirect @member, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      puts 'not persisted'
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_member_session_path
    end
  end

  def failure
    puts 'failure'
    redirect_to new_member_registration_path
  end

end

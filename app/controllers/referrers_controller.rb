class ReferrersController < ApplicationController
  skip_before_action :authenticate_member!, only: :check

  def check
    @referral_email = params[:email]
    @referrers_emails = []
    Member.all.each do |member|
      @referrers_emails << member.email
    end

    if @referrers_emails.include?(@referral_email)
      return redirect_to new_member_registration_path(referrer: "checked")
    else
      flash[:referrer_error] = "This person does not seem to be a Planisfer member."
      return redirect_to new_member_session_path(referrer: 'wrong_credentials')
    end

  end
end

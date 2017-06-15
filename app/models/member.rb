class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  serialize :passengers
  has_many :orders

  def email_required?
    false
  end

  def self.from_omniauth(auth)
    member_params = auth.slice(:provider, :uid)
    member_params.merge! auth.info.slice(:email, :first_name, :last_name)
    member_params[:facebook_picture_url] = auth.info.image
    member_params[:token] = auth.credentials.token
    member_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    member_params = member_params.to_h
    member = Member.find_by(provider: auth.provider, uid: auth.uid)
    member ||= Member.find_by(email: auth.info.email) # member did a regular sign up in the past.
    if member
      member.update(member_params)
    else
      raise
      member = Member.new(member_params)
      member.password = Devise.friendly_token[0,20]  # Fake password for validation
      member.save
    end
    return member
  end

  def self.new_with_session(params, session)
    super.tap do |member|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        member.email = data["email"] if member.email.blank?
      end
    end
  end

end

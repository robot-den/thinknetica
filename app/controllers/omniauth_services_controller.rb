class OmniauthServicesController < ApplicationController
  def new_email_for_oauth
  end

  def save_email_for_oauth
    email = params[:email]
    unless email.blank?
      provider = session[:provider]
      uid = session[:uid]
      auth = OmniAuth::AuthHash.new({ provider: provider, uid: uid, info: { email: email } })
      authorization = User.find_or_create_authorization(auth)
      OAuthMailer.email_confirmation(authorization).deliver_later
      flash[:notice] = 'Now you need to confirm your email. Check your mailbox'
      redirect_to new_user_session_path
    else
      render new_email_for_oauth_path
    end
  end

  def confirm_email
    provider = params[:provider]
    uid = params[:uid]
    hash = params[:token]
    authorization = Authorization.find_by(provider: provider, uid: uid)
    if authorization && authorization.confirmation_hash == hash
      hash = Devise.friendly_token[0, 20]
      authorization.update(confirmed: true, confirmation_hash: hash)
      redirect_to "/users/auth/#{provider}"
    else
      flash[:alert] = 'Something went wrong'
      redirect_to new_user_session_path
    end
  end
end

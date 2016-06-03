class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize
  end

  def twitter
    authorize
  end

  private

  def authorize
    authorization = User.find_or_create_authorization(request.env['omniauth.auth'])
    if authorization.nil?
      session[:provider] = request.env['omniauth.auth'].provider
      session[:uid] = request.env['omniauth.auth'].uid
      redirect_to new_email_for_oauth_path
    elsif authorization.provider == 'twitter' && !authorization.confirmed?
      flash[:alert] = 'You need to confirm your email. Check your mailbox'
      redirect_to new_user_session_path
    elsif authorization.user.persisted?
      sign_in_and_redirect authorization.user, event: :authentication
      set_flash_message(:notice, :success, kind: authorization.provider) if is_navigational_format?
    end
  end
end

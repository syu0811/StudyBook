# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :check_manual, only: [:new]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def check_manual
    session[:redirect_to] = false
    session[:redirect_to] = true if params[:redirect_to] == "manual"
  end

  def after_sign_in_path_for(_resource)
    if session[:redirect_to]
      information_manual_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end
end

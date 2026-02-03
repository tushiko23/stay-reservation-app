class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_profile
  before_action :store_user_location!, if: :storable_location?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private

  def set_header_profile
    return unless user_signed_in?
    @profile = current_user.profile || current_user.build_profile
  end

  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # 新規・編集画面に入った時に、"本当の前のページ"を保存する
  def set_previous_url
    return if @previous_url.present?
    @previous_url = request.referer if request.referer.present? && !request.referer.include?(request.path)
  end

  # フォーム送信（エラー時）に、隠しフィールドからURLを復元する
  def fetch_previous_url
    @previous_url = params[:previous_url]
  end
end

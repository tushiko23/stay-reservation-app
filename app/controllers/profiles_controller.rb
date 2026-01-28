class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def edit
    @profile = current_user.profile || current_user.build_profile
    @profile.user = current_user
  end

  def update
    @profile = current_user.profile || current_user.build_profile
    @user = current_user

    pp = profile_params

    name = pp.dig(:user_attributes, :name).to_s.strip
    intro = pp[:introduction].to_s.strip
    icon_present = pp.key?(:icon)

    if name.empty? && intro.empty? && !icon_present
      flash.now[:alert] = "どれか1つは入力してください"
      return render :edit, status: :unprocessable_entity
    end

  ActiveRecord::Base.transaction do
    profile_updates = {}
    profile_updates[:introduction] = intro
    profile_updates[:icon] = pp[:icon] if icon_present

    @profile.update!(profile_updates) if profile_updates.any?
    @user.update!(name: name)
  end

  redirect_to settings_path(tab: :profile), notice: 'プロフィールが更新されました'

  rescue ActiveRecord::RecordInvalid
    @user = current_user
    flash.now[:alert] = "プロフィールの更新に失敗しました"
    render :edit, status: :unprocessable_entity
  end

  private

    def profile_params
      params.require(:profile).permit(:introduction, :icon, user_attributes: [ :id, :name ])
    end
end

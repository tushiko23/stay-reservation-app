class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile || current_user.build_profile
  end
end

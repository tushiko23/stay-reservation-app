class Users::RegistrationsController < Devise::RegistrationsController
  protected

    def after_update_path_for(resource)
    settings_path(tab: :account)
    end
end

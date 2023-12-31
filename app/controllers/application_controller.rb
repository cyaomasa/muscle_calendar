class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!, if: :admin_url
  before_action :authenticate_user!, unless: :admin_url, except: [:top]
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
      
  def admin_url
    request.fullpath.include?("/admin")
  end
  
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end
  
  private
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        admin_users_path
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == :user
        new_user_session_path
      elsif resource_or_scope == :admin
        new_admin_session_path
      end
    end
end

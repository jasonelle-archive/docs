class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  acts_as_token_authentication_handler_for User
  respond_to :html, :json
  protect_from_forgery with: :null_session

  protected
  def authenticate_user!
    if self.request.format.html?
      super
    elsif self.request.format.json?
      if self.request.parameters["controller"].start_with?("devise")
        # use the default if session related
        super
      else
        # others
        if user_signed_in?
          # use the default if already signed in
          super
        else
          # serve the static login page if not signed in
          @data = File.read("#{Rails.root}/public/login.json")
          @data = @data.gsub(/ROOT/, root_url)
          render :json => @data
        end
      end
    end
  end
end

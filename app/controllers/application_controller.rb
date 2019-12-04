class ApplicationController < ActionController::Base
  include Pundit
  include ActionController::MimeResponds
  include ActionController::Live

  before_action :authenticate_request
  skip_before_action :verify_authenticity_token, if: :json_request?

  attr_reader :current_user

  protected

  # rubocop: disable Style/GuardClause
  def assure_admin!
    unless current_user.admin?
      redirect_back(fallback: root_path, fallback_location: root_path)
    end
  end

  # rubocop: enable Style/GuardClause

  private

  def json_request?
    request.format.json?
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers, session["auth_token"]).result
    respond_to do |format|
      format.html do
        # redirect_to root_url, notice: "No estás logueado" unless current_user
      end
      format.json do
        unless @current_user
          render json: { error: "Not Authorized" }, status: 401
        end
      end
    end
  end
end

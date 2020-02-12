class ApplicationController < ActionController::Base
  include Pundit
  include ActionController::MimeResponds
  include ActionController::Live

  before_action :authenticate_request
  before_action :set_last_seen_at, if: lambda {
                                         !current_user.nil? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago)
                                       }
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

  def set_last_seen_at
    current_user.update_column(:last_seen_at, Time.zone.now)
  end

  def allow_only_html
    return if request.format.html?

    render json: { error: "Not Authorized" }, status: 401
  end

  def json_request?
    request.format.json?
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers, session["auth_token"]).result
    respond_to do |format|
      format.html do
        unless @current_user&.admin?
          redirect_to login_url, notice: "No estás logueado o no sos admin."
        end
      end
      format.json do
        unless @current_user
          render json: { error: "Not Authorized" }, status: 401
        end
      end
    end
  end
end

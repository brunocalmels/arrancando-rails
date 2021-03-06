class ApplicationController < ActionController::Base
  include Pundit
  include ActionController::MimeResponds
  include ActionController::Live

  before_action :authenticate_request
  before_action :set_last_seen_at, if: lambda {
                                         !current_user.nil? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago)
                                       }
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_request, only: %i[app_version]

  attr_reader :current_user

  def app_version
    render json: { version: APP_VERSION }
  end

  # Lograge setup (https://www.papertrail.com/solution/tips/seven-typical-problems-with-logging-ruby-and-how-to-solve-them/)
  def append_info_to_payload(payload)
    super
    payload[:level] = if payload[:status] == 200
                        "INFO"
                      elsif payload[:status] == 302
                        "WARN"
                      else
                        "ERROR"
                      end
  end

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

  def public_page?
    params[:controller].in?(CONTROLADORES_PUBLICOS) &&
      params[:action].in?(ACCIONES_PUBLICAS)
  end

  def home_page?
    params[:controller] == "home" &&
      params[:action] == "index"
  end

  def xls_permitted?
    params[:controller] == "users" &&
      params[:action] == "index"
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers, session["auth_token"]).result
    respond_to do |format|
      format.html do
        unless @current_user&.admin? || public_page? || home_page?
          redirect_to(root_path, notice: "No est??s logueado o no sos admin.")
        end
      end
      format.json do
        unless @current_user
          render json: { error: "Not Authorized" }, status: 401
        end
      end
      format.xls do
        unless @current_user&.admin? && xls_permitted?
          redirect_to(root_path, notice: "No est??s logueado o no sos admin.")
        end
      end
    end
  end

  # rubocop: enable Metrics/CyclomaticComplexity

  def set_ciudades
    @ciudades = Ciudad.eager_load(:provincia).order(nombre: :asc)
  end
end

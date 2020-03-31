class CiudadPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.admin?
  end

  def importacion_masiva?
    index?
  end
end

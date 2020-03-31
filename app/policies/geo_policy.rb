class GeoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    user&.admin?
  end

  def new?
    edit?
  end

  def create?
    edit?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def importacion_masiva?
    edit?
  end
end

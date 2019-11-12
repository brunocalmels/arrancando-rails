class PoiPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.admin? || user == record.user
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end

class EventPolicy < ApplicationPolicy
  def private?
    @user && (@record.kind == 'private')
  end

  def own?
    @user && (@user == @record.user)
  end

  def subscribed?
    Subscription.find_by(user: @user, event: @record)
  end
end

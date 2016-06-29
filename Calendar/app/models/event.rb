class Event < ActiveRecord::Base
  validates :name, :start_time, presence: true
  has_many :subscriptions
  belongs_to :user

end

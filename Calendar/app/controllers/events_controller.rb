class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  respond_to :html
  helper EventsHelper

  def index
    @events = Event.where("kind = ? or user_id = ?", "global", current_user.id)
  end

  def show
    @policy = event_policy(@event)
  end

  def edit
  end

  def new
    @event = current_user.events.new
  end

  def subscribe
    @event = Event.find(params[:event_id])
    if !event_policy(@event).subscribed?
      @subscription = subscribe_create(@event)
      redirect_to event_path(@event), notice: 'You was successfully subscribed on this event'
    else
      redirect_to event_path(@event), notice: 'You are already subscribed on this event'
    end
  end

  def unsubscribe
    @event = Event.find(params[:event_id])
    if !event_policy(@event).subscribed?
      redirect_to event_path(@event), notice: 'You are not subscribed on this event yet'
    else
      @subscription = Subscription.find_by(user: current_user, event: @event)
      @subscription.destroy
      redirect_to event_path(@event), notice: 'You were unsubscribed from this event'
    end
  end

  def create
    @event = current_user.events.create(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_url, notice: 'Event was successfully created.'
    else
      redirect_to new_event_url, notice: 'Error'
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, notice: 'Error'
    end
  end

  def destroy
    @event.destroy
    redirect_to root_path, notice: 'Event was successfully deleted'
  end

  def subscribed_events
    @events = current_user.events
  end

  private
  def event_params
    params.require(:event).permit(:name, :start_time, :user_id, :kind)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def subscribe_create(event)
    @subscription = Subscription.create(user: current_user, event: event)
  end

  def event_policy(event)
    @policy = EventPolicy.new(current_user, event)
  end
end

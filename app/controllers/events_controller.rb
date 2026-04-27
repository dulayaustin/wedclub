class EventsController < ApplicationController
  before_action :require_account
  before_action :set_event, only: %i[show edit update]

  def index
    render Views::Events::Index.new(events: current_account.events)
  end

  def show
    render Views::Events::Show.new(event: @event)
  end

  def edit
    render Views::Events::Edit.new(event: @event)
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: "Event updated."
    else
      render Views::Events::Edit.new(event: @event), status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = current_account.events.find(params[:id])
    set_event_session(@event)
  end

  def event_params
    params.expect(event: [ :title, :event_date, :theme ])
  end
end

class Admin::CommunityEventsController < Admin::BaseController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @events = CommunityEvent.order(starts_at: :desc)
  end

  def new
    @event = CommunityEvent.new(starts_at: 1.week.from_now)
  end

  def create
    @event = CommunityEvent.new(event_params)
    if @event.save
      redirect_to admin_community_events_path, notice: "Event created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to admin_community_events_path, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_community_events_path, notice: "Event deleted."
  end

  private

  def set_event
    @event = CommunityEvent.find(params[:id])
  end

  def event_params
    params.require(:community_event).permit(:title, :description, :location, :event_type, :starts_at, :ends_at, :published)
  end
end

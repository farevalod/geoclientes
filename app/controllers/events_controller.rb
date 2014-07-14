class EventsController < ApplicationController
  before_filter :authenticate_user!

  def create
	  @event = Event.new(params[:event])
	  @event.user = User.find(params[:user_id])
	  @event.contact = Contact.find(params[:contact_id])
	  @event.save
	  redirect_to '/events'
  end
  def show
	  @event = Event.find(params[:id])
  end
  def index
	  if current_user.role == 2
		  @events = Event.all
	  elsif current_user.role == 1
		  current_user.users.each do |u|
			  @events.append(u.events)
		  end
	  else
		  @events = current_user.events
	  end

	  @locs = []
	  @events.each do |e|
		  @point = [e.contact.name+" - "+e.contact.customer.name, e.contact.customer.latitude, e.contact.customer.longitude]
		  @locs.push(@point)
	  end

	      respond_to do |format|
			format.html # show.html.erb
		    format.json  { render :json => @events }
		  end
  end
  def check_in
	  @event = Event.find(params[:id])
	  if current_user.distance_from([@event.contact.customer.latitude,@event.contact.customer.longitude]) < 5
		  @event.status = 1 #checked-in
		  @event.save
	  end
	  respond_to do |format|
		format.json  { render :json => @event }
	  end
  end
end

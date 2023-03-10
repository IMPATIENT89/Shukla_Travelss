class BookingsController < ApplicationController

    before_action :require_customer_login

    def new
        @booking = Booking.new
    end

    def show
        @booking = Booking.find(params[:id])
    end
  
    def index
      @bookings = Booking.all
    end

    def create
        @booking = Booking.new(booking_params)
        @booking.customer = current_customer
        if @booking.save
          BookingMailer.booking_confirmation(@booking).deliver_now
          redirect_to @booking, notice: "Booking is done"
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
      @booking = Booking.find(params[:id])
    end

  def update
      @booking = Booking.find(params[:id])
      if @booking.update(booking_params)
          redirect_to @booking, notice: "Your trip was successfully updated"
      else
          render :edit, status: :unprocessable_entity
      end       
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path, notice: "Your trip was successfully deleted"
  end
    
    private

    def booking_params
      params.require(:booking).permit(:how_many_people, :booking_from, :booking_to, :booking_date, :choose_car, vehicle_ids: [])
    end

    def require_customer_login
      unless logged_in_as_customer?
        flash[:alert] = "Please log in to continue the booking."
        redirect_to sign_in_customer_path
      end
    end

   
end

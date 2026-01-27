class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy ]
  before_action :set_room_reservation, only: [ :confirm, :create ]
  def index
    @reservations = current_user.reservations
  end

  def new
    if session[:reservation_params].present?
      room_id = session[:reservation_params]["room_id"] || session[:reservation_params][:room_id]
      @room = Room.find(room_id)
      @reservation = current_user.reservations.build(session[:reservation_params])
    else
      set_room_reservation
      @reservation = current_user.reservations.build(room: @room)
      session.delete(:reservation_params)
    end
  end

  def confirm
    @reservation = current_user.reservations.build(reservation_params.merge(room: @room))

    if @reservation.valid?
      session[:reservation_params] = reservation_params.merge(room_id: @room.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    redirect_to reservations_path, notice: "すでに予約は作成されています" and return if session[:last_reservation_id].present?

    room_id = session.dig(:reservation_params, "room_id") || session.dig(:reservation_params, :room_id)
    @room = Room.find(room_id)

    @reservation = current_user.reservations.build(session[:reservation_params])

    if @reservation.save
      session[:last_reservation_id] = @reservation.id
      session.delete(:reservation_params)
      redirect_to reservations_path, notice: "予約が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
    
  end

  def edit

  end

  def update
    if @reservation.update(reservation_params)
      redirect_to reservation_path(@reservation), notice: "施設先を編集しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, status: :see_other, notice: "予約を削除しました"
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def set_room_reservation
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in_date, :check_out_date, :guest_count, :room_id)
  end
end

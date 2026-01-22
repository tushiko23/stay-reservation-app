class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_room, only: [ :show, :edit, :update, :destroy ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  def index
    @rooms = Room.all
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to room_path(@room), notice: "施設が登録されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def own
    @rooms = current_user.rooms
  end

  def edit

  end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: "施設先を編集しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, status: :see_other, notice: "施設を削除しました"
  end
end

private

  def set_room
    @room = Room.find(params[:id])
  end

  def correct_user
    return if @room.user == current_user
    flash[:alert] = "その操作はルームを作成したユーザのみができます"
    redirect_to room_path(@room)
  end

  def room_params
    params.require(:room).permit(:name, :introduction, :fee_per_day, :address, :image)
  end

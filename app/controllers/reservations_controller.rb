class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy ]
  before_action :set_room_reservation, only: [ :new, :confirm, :create ]
  before_action :set_previous_url, only: [ :index ]
  before_action :fetch_previous_url, only: [ :new, :confirm, :create ]
  def index
    @reservations = current_user.reservations
  end

  def new
    @previous_url = params[:previous_url] || request.referer

    # 【重要】もし取得したURLが「自分自身」や「確認画面」なら、上書きせずに「お部屋詳細」などをデフォルトにする
    if @previous_url.present? && (@previous_url.include?("/reservations/new") || @previous_url.include?("/confirm"))
      # 既にバケツリレーが壊れている場合やリロード対策として、@previous_url を書き換えない工夫
      # 何もしない、もしくは @room の詳細ページを代入しておく
      @previous_url = params[:previous_url] if params[:previous_url].present?
    end

    if params[:back] && session[:reservation_params].present?
      @reservation = current_user.reservations.build(session[:reservation_params])
    else
      @reservation = current_user.reservations.build(room: @room)
      session.delete(:reservation_params)
    end
  end

  def confirm
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room = @room # room_id が missing でも before_action でセット済み

    if @reservation.valid?
      session[:reservation_params] = reservation_params.merge(room_id: @room.id)
    else
      # エラー時は new を表示。この時 @room が必要。
      render :new, status: :unprocessable_entity
    end
  end

  def create
    # session[:reservation_params] が空（＝一度保存して削除済み）なのに
    # createにアクセスしてきた場合は、既に処理済みとみなしてリダイレクト
    if session[:reservation_params].blank?
      return redirect_to reservations_path, notice: "セッションがタイムアウトしたか、既に予約済みです"
    end

    @reservation = current_user.reservations.build(session[:reservation_params])
    @reservation.room = @room

    if @reservation.save
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

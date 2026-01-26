class HomeController < ApplicationController
  before_action :set_q, only: [ :index ]
  def index
    @rooms = @q.result(distinct: true)
  end

private
  def set_q
    @q = Room.ransack(params[:q])
  end
end

class StatisticsController < ApplicationController
  # GET /statistics
  # GET /statistics.json
  before_filter :authenticate_user!
  def index
    @date_from = params[:date_from]
    @date_from = (Time.now - 7.days).strftime("%Y-%m-%d") if @date_from == nil

    @date_to = params[:date_to]
    @date_to = Time.now.strftime("%Y-%m-%d") if @date_to == nil

    @statistics = current_user.account.statistics.select("date, sum(views) as views").where('date >= ? AND date <= ?', parse_integer(@date_from), parse_integer(@date_to)).group("date").order('date DESC')


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statistics }
    end
  end

  # GET /statistics/1
  # GET /statistics/1.json
  def show


    date_to = params[:date_to]

    redirect_to root_path and return false unless params[:date]
    @date = params[:date]
    @statistics = current_user.account.statistics.where('date = ?', params[:date])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @statistic }
    end
  end

  # GET /statistics/new
  # GET /statistics/new.json
end

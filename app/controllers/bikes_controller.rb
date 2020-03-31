class BikesController < ApplicationController
  before_action :set_brand, only: :create
  before_action :set_bike, only: :update

  def create
    # before_actionの set_brand で @brand 取得
    bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
    if bike.save
      # 登録成功
      response_success_created(bike)
    else
      # 何らかの理由で保存できない場合
      response_not_created(bike)
    end
  end

  def index
    brand = Brand.find_by(name: params[:brand_name])
    if brand
      bikes = Bike.where(brand_id: brand.id).select(:id, :serial_number, :sold_at)
      data = datetime_to_strftime(bikes)
      data = JSON.pretty_generate(data: data)
      render json: data
    else # ブランド名が見つからない場合
      response_not_found('Brand')
    end
  end

  def update
    # before_action の set_bike で @bike　取得
    if @bike.sold_at.nil? # 自転車が存在し、かつ まだ売れていないとき
      @bike.set_sold_at # sold_atにTime.nowを代入
      if @bike.save
        response_success_update(@bike)
      else
        # 何らかの理由でupdateできない
        response_not_created(@bike)
      end
    else # 自転車は存在するが、すでに売れたとき
      response_not_updated(@bike)
    end
  end

  private

  def set_brand
    @brand = Brand.find_by(name: params[:brand_name])
    if @brand.nil? # rubocop:disable all 直感的にわかりづらい unless文になるため
      # ブランド名が登録されていない場合
      brand = Brand.new(name: params[:brand_name])
      if brand.save
        @brand = brand
      else
        # 何らかの理由でブランドが作成できない場合
        response_not_created(brand)
      end
    end
  end

  def set_bike
    @bike = Bike.find_by(serial_number: params[:serial_number])
    response_not_found('Bike') if @bike.nil? # 自転車が存在しなければ、not_foundを返す
  end

  def bike_params
    params.permit(:brand_name, :serial_number)
  end
end

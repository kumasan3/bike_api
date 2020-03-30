class BikesController < ApplicationController
  before_action :set_brand, only: :create

  def create
      # before_actionの set_brand で @brand 取得
      bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
      if bike.save
        # 登録成功
        response_success_created(bike)
      else
        #何らかの理由で保存できない場合
        response_not_created(bike)
      end
  end

  def index
    brand = Brand.find_by(name: params[:brand_name] )
    if brand
      bikes = Bike.where( brand_id: brand.id) .select(:id, :serial_number, :sold_at)
      data = []
      bikes.each do |bike| #datetime型を、日本語の日付に変換
        data = data.push({id: bike.id, serial_number: bike.serial_number, sold_at: bike.datetime_to_strftime})
      end
      render json: { data: data }
    else #ブランド名が見つからない場合
      response_not_found("Brand")
    end
  end

  def update
    bike = Bike.find_by(serial_number: params[:serial_number])
    if bike && bike.sold_at == nil #自転車が存在し、まだ売れていないとき
      bike.set_sold_at #sold_atにTime.nowを代入
      if bike.save
        response_success_update(bike)
      else
        # 何らかの理由でupdateできない
        response_not_created(bike)
      end
    elsif bike #自転車は存在するが、すでに売れたとき
      response_not_updated(bike)
    else
      response_not_found("Bike")
    end
    

  end

  private
  def set_brand
    @brand = Brand.find_by(name: params[:brand_name])
    if @brand.nil?
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

  def bike_params
    params.permit( :brand_name, :serial_number ) 
  end

end

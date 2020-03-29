class BikesController < ApplicationController
  before_action :set_brand, only: :create
  
  def create
      # before_actionの set_brand で @brand 取得
      bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
      if bike.save
        # 登録成功
        render status: :created, json: { status: 201, message: "succesfully registered!" }
      else
        #何らかの理由で保存できない場合
        render status: :unprocessable_entity, json: { status: 422, error: bike.errors.full_messages }
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
      render status: 404, json: { status: 404, error: "Brand name cannot be found"}
    end
  end

  def update
    bike = Bike.find_by(serial_number: params[:serial_number])
    if bike && bike.sold_at == nil
      bike.set_sold_at
      if bike.save
        render status: 200, json: {status: 200, message: "Congratulations! Bike is sold"}
      else
        # 何らかの理由でupdateできない
        render status: 422, json: {status: 422}
      end
    elsif bike
      render status: 404, json: { status: 404, message: "Bike already sold out!"}
    else
      render status: 404, json: { status: 404, error: "Bike does not exist"}
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
        render status: :unprocessable_entity, json: { status: 422, error: brand.errors.full_messages }
      end
    end
  end
end

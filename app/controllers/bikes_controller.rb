class BikesController < ApplicationController
  before_action :set_brand, only: :create
  def create
    if @brand
      # before_actionでブランド参照
      bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
      if bike.save
        # バイク登録成功
        render status: :created, json: { status: 201 }
      else
        render status: :unprocessable_entity, json: { status: 422, error: bike.errors.full_messages }
      end
    else
      render status: :unprocessable_entity, json: { status: 422, error: bike.errors.full_messages }
    end
  end

  def index
    # bikes = Bike.where(name: params[:brand_name])
    # render status: :created, json: { status: 201, data:[bikes] }
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

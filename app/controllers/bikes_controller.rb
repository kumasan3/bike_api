class BikesController < ApplicationController
  def create
    @brand = Brand.find_by(name: params[:brand_name])
    if @brand.nil?
      brand = Brand.new(name: params[:brand_name])
      @brand = brand if brand.save
    end
    bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
    if bike.save
      render json: { status: 201 }
    else
      render json: { status: 422 }
    end
  end

  def set_brand; end
end

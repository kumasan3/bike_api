class BikesController < ApplicationController

    def create
        @brand = Brand.find_by(brand: params[:brand_name])
        if @brand.nil?
            brand = Brand.new(name: params[:brand_name])
            if brand.save
                @brand = brand
            end
        end
        bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number].to_i)
        render json: { status: 'SUCCESS', message: 'ハローワールド！！', }
    end

    def set_brand
        
        
    end

end

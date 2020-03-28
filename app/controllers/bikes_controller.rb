class BikesController < ApplicationController
    before_action :set_brand, only: :create
    def create
        @brand = Brand.find_by(name: params[:brand_name])
        if @brand.nil?
            brand = Brand.new(name: params[:brand_name])
            @brand = brand if brand.save
        end
        if @brand
            bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
            if bike.save
                render status: 201, json: { status: 201 }
            end
        else
            puts "jopjjpiji422"
            render status: 422, json: { status: 422 }
        end
    end

    def set_brand
        
    end

end

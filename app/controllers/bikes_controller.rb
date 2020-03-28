class BikesController < ApplicationController
    before_action :set_brand, only: :create
    def create
        if @brand
            # before_actionでブランド参照
            bike = Bike.new(brand_id: @brand.id, serial_number: params[:serial_number])
            if bike.save
                # バイク登録成功
                render status: 201, json: { status: 201 }
            else
                render status: 422, json: { status: 422, error: bike.errors.full_messages }
            end
        else
            puts "jopjjpiji422"
            render status: 422, json: { status: 422, error: bike.errors.full_messages }
        end
    end

    def set_brand
        @brand = Brand.find_by(name: params[:brand_name])
        if @brand.nil?
            # ブランド名が登録されていない場合
            brand = Brand.new(name: params[:brand_name])
            if brand.save
                @brand = brand
            else
                # 何らかの理由でブランドが作成できない場合
                render status: 422, json: { status: 422, error: brand.errors.full_messages }
            end
        end
    end

end

require 'rails_helper'

RSpec.describe "Inventory", type: :request do
    describe "自転車登録 API " do
        context "リクエストの brand_name が brands テーブルの name に存在しない場合" do
            it 'brand_nameとserial_numberで自転車情報を登録できること' do
                post "/bikes", params: {brand_name: "HONDA", serial_number: "12345"}
                bike = Bike.find_by(serial_number: "12345")
                expect(response).to have_http_status(201)
                expect(bike.brand.name).to eq("HONDA")
            end
            it 'brand_nameが無ければ登録できないこと' do
                post "/bikes", params: {brand_name: "", serial_number: "12345"}
                bike = Bike.find_by(serial_number: "12345")
                puts response.body
                expect(response).to have_http_status(422)
                expect(bike.nil?).to eq(true)
            end
            

        end
    end
end
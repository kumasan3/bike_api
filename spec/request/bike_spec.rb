require 'rails_helper'

RSpec.describe "Inventory", type: :request do
    describe "自転車登録 API " do
        before do
            @brand = FactoryBot.create(:brand, name: "SUZUKI")
            @bike = FactoryBot.create(:bike, brand_id: @brand.id)
            @count_before = Bike.count
        end
        context "リクエストの brand_name が brands テーブルの name に存在しない場合" do
            it 'brand_nameとserial_numberで自転車情報を登録できること' do
                post "/bikes", params: {brand_name: "HONDA", serial_number: "12345"}
                expect(response).to have_http_status(201)
                expect(Bike.count).to eq(@count_before + 1)
            end
            it 'brand_nameが無ければ登録できないこと' do
                post "/bikes", params: {brand_name: "", serial_number: "12345"}
                bike = Bike.find_by(serial_number: "12345")
                expect(response).to have_http_status(422)
                expect(bike.nil?).to eq(true)
                expect(Bike.count).to eq(@count_before)
            end
            it 'brand_nameが無ければ登録できないこと #2' do
                post "/bikes", params: {brand_name: nil, serial_number: "12345"}
                bike = Bike.find_by(serial_number: "12345")
                expect(response).to have_http_status(422)
                expect(bike.nil?).to eq(true)
                expect(Bike.count).to eq(@count_before)
            end
            it 'serial numberが無ければ登録できないこと' do
                post "/bikes", params: {brand_name: "HONDA", serial_number: ""}
                expect(@count_before).to eq(Bike.count)
                expect(response).to have_http_status(422)
                expect(Bike.count).to eq(@count_before)
            end
            it 'serial numberが無ければ登録できないこと #2' do
                post "/bikes", params: {brand_name: "HONDA", serial_number: nil}
                expect(@count_before).to eq(Bike.count)
                expect(response).to have_http_status(422)
                expect(Bike.count).to eq(@count_before)
            end
            it '既に存在するserial numberでは登録できないこと' do
                post "/bikes", params: {brand_name: "HONDA", serial_number: @bike.serial_number}
                expect(@count_before).to eq(Bike.count)
                expect(response).to have_http_status(422)
                expect(Bike.count).to eq(@count_before)
            end

        end
    end
end
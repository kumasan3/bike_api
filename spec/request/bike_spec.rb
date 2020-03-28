require 'rails_helper'

RSpec.describe 'Inventory', type: :request do
  describe '自転車登録 API ' do
    before do
      @brand = FactoryBot.create(:brand, name: 'SUZUKI')
      @bike = FactoryBot.create(:bike, brand_id: @brand.id)
      @count_before = Bike.count
    end
    context 'リクエストの brand_name(HONDA) が brands テーブルの name に存在しない場合' do
      it 'brand_nameとserial_numberで自転車情報を登録できること' do
        post '/bikes', params: { brand_name: 'HONDA', serial_number: '12345' }
        expect(response).to have_http_status(201)
        expect(Bike.count).to eq(@count_before + 1)
      end
      it 'brand_nameが無ければ登録できないこと' do
        post '/bikes', params: { brand_name: '', serial_number: '12345' }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it 'brand_nameが無ければ登録できないこと #2' do
        post '/bikes', params: { brand_name: nil, serial_number: '12345' }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it 'serial numberが無ければ登録できないこと' do
        post '/bikes', params: { brand_name: 'HONDA', serial_number: '' }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it 'serial numberが無ければ登録できないこと #2' do
        post '/bikes', params: { brand_name: 'HONDA', serial_number: nil }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it '既に存在するserial numberでは登録できないこと' do
        post '/bikes', params: { brand_name: 'HONDA', serial_number: @bike.serial_number }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
    end
    context 'リクエストの brand_name(SUZUKI) が brands テーブルの name に存在する場合' do
      it '既に存在するbrand_name(SUZUKI)でbikeを登録できること' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: '6789' }
        expect(response).to have_http_status(201)
        expect(Bike.count).to eq(@count_before + 1)
      end
      it '既に存在するserial_numberではbikeを登録できないこと' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: @bike.serial_number }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it 'serial numberが無ければ登録できないこと' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: '' }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
      it 'serial numberが無ければ登録できないこと #2' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: nil }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(@count_before)
      end
    end
    context 'リクエストのHTTPメソッドが異なる場合' do
      it 'GET メソッドの場合にbikeは登録されないこと' do
        get '/bikes', params: { brand_name: 'SUZUKI', serial_number: '6789' }
        expect(Bike.count).to eq(@count_before)
      end
    end
  end


  describe '自転車情報取得 API ' do
    before do
      @brand = FactoryBot.create(:brand, name: 'SUZUKI')
      @bike = FactoryBot.create(:bike, brand_id: @brand.id)
    end
  end

end

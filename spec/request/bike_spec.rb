require 'rails_helper'

RSpec.describe 'Inventory', type: :request do
  describe '自転車登録 API。メソッド：POST　　URL：/bikes ' do
    context 'リクエストの brand_name が brands テーブルの name カラムに存在しないとき' do
      let(:params) { { brand_name: 'HONDA', serial_number: 'A12345' } }
      let!(:bike_count_before) { Bike.count } # let!で評価前に実行

      it 'ブランド名が brandsテーブルのnameカラムに登録されること' do
        post '/bikes', params: params
        brand = Brand.find_by(name: 'HONDA')
        expect(brand.nil?).to eq(false)
      end

      it 'brand_nameとserial_numberで自転車情報を登録できること' do
        post '/bikes', params: params
        expect(response).to have_http_status(201)
        expect(Bike.count).to eq(bike_count_before + 1) # 1台分レコードが増える
      end

      it 'brand_nameが無ければ登録できないこと' do
        post '/bikes', params: params.merge!(brand_name: '')
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end

      it 'brand_nameが無ければ登録できないこと #2' do
        post '/bikes', params: params.merge!(brand_name: nil)
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end

      it 'serial numberが無ければ登録できないこと' do
        post '/bikes', params: params.merge!(serial_number: '')
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end

      it 'serial numberが無ければ登録できないこと #2' do
        post '/bikes', params: params.merge!(serial_number: nil)
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end

      it '既に存在するserial numberでは登録できないこと' do
        post '/bikes', params: params
        post '/bikes', params: params
        expect(response).to have_http_status(422) # エラーレスポンス
        expect(Bike.count).to eq(bike_count_before + 1) # 登録されるのは1台のみ
      end
    end

    context 'リクエストの brand_name(SUZUKI) が brands テーブルの name にすでに存在するとき' do
      before do
        @brand = FactoryBot.create(:brand, name: 'SUZUKI') # SUZUKiブランドを最初に登録。
      end
      let(:params) { { brand_name: @brand.name, serial_number: 'A12345' } }
      let!(:bike_count_before) { Bike.count } # let!で評価前に実行
      let!(:brand_count_before) { Brand.count } # let!で評価前に実行

      it '同じブランド名は重複して登録されないこと' do
        post '/bikes', params: params
        expect(response).to have_http_status(201)
        expect(Brand.count).to eq(brand_count_before) # ブランドテーブルのレコード数は同じ
      end

      it '既に存在するbrand_name(SUZUKI)でbikeを登録できること' do
        post '/bikes', params: params
        expect(response).to have_http_status(201)
        expect(Bike.count).to eq(bike_count_before + 1)
      end

      it '既に存在するserial_numberではbikeを登録できないこと' do
        post '/bikes', params: params
        post '/bikes', params: params
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before + 1) # 登録されるのは1台のみ
      end

      it 'serial numberが無ければ登録できないこと' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: '' }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end

      it 'serial numberが無ければ登録できないこと #2' do
        post '/bikes', params: { brand_name: 'SUZUKI', serial_number: nil }
        expect(response).to have_http_status(422)
        expect(Bike.count).to eq(bike_count_before)
      end
    end
  end

  describe '自転車情報取得 API　メソッド:GET、　URL：/bikes ' do
    before do
      brand = FactoryBot.create(:brand, name: 'SUZUKI')
      5.times do
        FactoryBot.create(:bike, brand_id: brand.id)
      end
    end
    context 'ブランド名をbrand_nameパラメータに含めGETリクエストするとき' do
      it 'レスポンスの自転車一覧が5つ入っていること' do
        get '/bikes', params: { brand_name: 'SUZUKI' }
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq(5)
      end

      it 'レスポンスの自転車一覧の中にシリアルナンバーが入っていること' do
        get '/bikes', params: { brand_name: 'SUZUKI' }
        brand = Brand.find_by(name: 'SUZUKI')
        bikes = Bike.where(brand_id: brand.id)
        bikes.each do |bike|
          expect(response.body).to include(bike.serial_number) # responseに、シリアルナンバーが入っている
        end
      end

      it '存在しないブランド名を入力すると、エラーレスポンスが返ること' do
        get '/bikes', params: { brand_name: 'OPPO' }
        expect(response).to have_http_status(404)
      end
    end

    context 'brand_nameパラメータが空のとき' do
      it 'ブランド名が無い場合、エラーレスポンスが返ること' do
        get '/bikes', params: { brand_name: '' }
        expect(response).to have_http_status(404)
      end

      it 'ブランド名が無い場合、エラーレスポンスが返ること #2' do
        get '/bikes', params: { brand_name: nil }
        expect(response).to have_http_status(404)
      end

      it 'ブランド名が無い場合、エラーレスポンスが返ること #3' do
        get '/bikes'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '自転車売却 API  メソッド：PATCH  URL：/bikes/[ブランド名]' do
    let(:brand) { FactoryBot.create(:brand, name: 'SUZUKI') }
    let(:bike1) { FactoryBot.create(:bike, brand_id: brand.id) }

    context '売却する前のとき' do
      it 'Bikeテーブルのsold_atカラムは、nilであること' do
        expect(bike1.sold_at).to eq(nil) # 元々、sold_atはnil
      end
    end

    context '存在する自転車のserial_numberでPATCHリクエストされたとき' do
      it 'Bikeテーブルのsold_atカラムにdatetime型の日付が登録されること' do
        patch "/bikes/#{bike1.serial_number}"
        bike1_after = Bike.find_by(serial_number: bike1.serial_number)
        expect(bike1_after.sold_at.nil?).to eq(false)
      end

      it 'Bikeテーブルのsold_atカラムの日付はdatetime型であること' do
        patch "/bikes/#{bike1.serial_number}"
        bike1_after = Bike.find_by(serial_number: bike1.serial_number)
        expect(bike1_after.sold_at.is_a?(Time)).to eq(true)
      end

      it '売却に成功すると200のHTTPステータスコードが返ること' do
        patch "/bikes/#{bike1.serial_number}"
        expect(response).to have_http_status(200)
      end

      it '既に売却された自転車は、再売却できないこと(Bikeテーブルsold_atカラムの更新不可)' do
        patch "/bikes/#{bike1.serial_number}"
        patch "/bikes/#{bike1.serial_number}" # 2回目
        expect(response).to have_http_status(404)
      end
    end

    context '存在しない自転車のserial_numberでPATCHリクエストされた場合' do
      it '自転車が見つからないため、404エラーが返ること' do
        patch '/bikes/random'
        expect(response).to have_http_status(404)
      end
    end
  end
end

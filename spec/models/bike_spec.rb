require 'rails_helper'

RSpec.describe Bike, type: :model do
  describe ' Bikeモデルのテスト' do
    context 'brand_name が brands テーブルの name に存在する場合' do

      let(:brand) { FactoryBot.create(:brand) }
      let(:params) {{ brand_id: brand.id, serial_number: 'A123' }}

      it 'ブランドIDとシリアルナンバーで自転車を登録できること #1' do 
        bike = Bike.create(params)
        expect(bike.valid?).to eq(true)
      end

      it 'ブランドIDとシリアルナンバーで自転車を登録できること #2' do #レコードの増加確認
        expect{ Bike.create(params) }.to change{ Bike.count }.from(0).to(1)
      end

      it 'シリアルナンバーがnilの場合には登録できないこと #1' do
        params.merge!(serial_number: nil)
        expect{ Bike.create(params) }.not_to change{ Bike.count }
      end

      it 'シリアルナンバーがnilの場合には登録できないこと #2' do
        params.merge!(serial_number: '')
        expect{ Bike.create(params) }.not_to change{ Bike.count }
      end

      it '重複するシリアルナンバーでは登録できないこと' do
        bike1 = Bike.create(params) # rubocop:disable all
        bike2 = Bike.create(params) # rubocop:disable all
        expect(bike2.errors).to be_added(:serial_number, :taken, value: params[:serial_number])
      end

      it 'ブランドは重複しても、serial_numberが異なれば登録できること' do
        bike1 = Bike.create(params) # rubocop:disable all
        params.merge!(serial_number: "B456")
        bike2 = Bike.create(params) # rubocop:disable all
        expect(bike2.valid?).to eq(true)
      end
    end

    context 'brand_name が brands テーブルの name に存在しない場合' do
      let(:brand) { FactoryBot.create(:brand) }
      let(:params) {{ brand_id: brand.id, serial_number: 'A123' }}
      # 存在しないbrand_nameで
      it '存在しないbrand_idだと登録できないこと #1' do
        params.merge!(brand_id: "random")
        expect{ Bike.create(params) }.not_to change{ Bike.count }
      end

      it 'ブランドIDがnilの場合には登録できないこと #1' do
        params.merge!(brand_id: nil)
        expect{ Bike.create(params) }.not_to change{ Bike.count }
      end

      it 'ブランドIDがnilの場合には登録できないこと #2' do
        params.merge!(brand_id: '')
        expect{ Bike.create(params) }.not_to change{ Bike.count }
      end
    end
  end

  describe ' Bikeテーブル バイク売却時の sold_at カラム更新のテスト' do
    context 'Bikeテーブルのsold_atカラムが更新できること' do
      let(:brand) { FactoryBot.create(:brand) }
      let(:params) {{ brand_id: brand.id, serial_number: 'A123' }}
      let(:bike) { Bike.create(params) }

      it "sold_atカラムにdatetime型の日付を入れれること" do
        bike.sold_at = Time.now
        bike.save
        expect(bike.sold_at.nil?).to eq(false)
        expect(bike.valid?).to eq(true)
      end

      it "sold_atカラムにdatetime型以外のデータ型は代入できないこと #1" do
        bike.sold_at = "2020年3月29日"
        expect(bike.sold_at.nil?).to eq(true)
      end

      it "sold_atカラムにdatetime型以外のデータ型は代入できないこと #2" do
        bike.sold_at = 20200306
        expect(bike.sold_at.nil?).to eq(true)
      end

    end
  end


end

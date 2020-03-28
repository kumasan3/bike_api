require 'rails_helper'

RSpec.describe Bike, type: :model do
  context 'brand_name が brands テーブルの name に存在する場合' do
    before do
      @brand = FactoryBot.create(:brand)
      @params = { brand_id: @brand.id, serial_number: '123' }
    end
    it 'ブランドIDとシリアルナンバーで登録できること ' do
      bike = Bike.create(@params)
      expect(bike.valid?).to eq(true)
    end
    it 'ブランドIDがnilの場合には登録できないこと #1' do
      @params.merge!(brand_id: nil)
      bike = Bike.create(@params)
      expect(bike.errors).to be_added(:brand_id, :blank)
    end
    it 'ブランドIDがnilの場合には登録できないこと #2' do
      @params.merge!(brand_id: '')
      bike = Bike.create(@params)
      expect(bike.errors).to be_added(:brand_id, :blank)
    end
    it 'シリアルナンバーがnilの場合には登録できないこと #1' do
      @params.merge!(serial_number: nil)
      bike = Bike.create(@params)
      expect(bike.errors).to be_added(:serial_number, :blank)
    end
    it 'シリアルナンバーがnilの場合には登録できないこと #2' do
      @params.merge!(serial_number: '')
      bike = Bike.create(@params)
      expect(bike.errors).to be_added(:serial_number, :blank)
    end
    it '重複するシリアルナンバーでは登録できないこと' do
      bike1 = Bike.create(@params) # rubocop:disable all
      bike2 = Bike.create(@params) # rubocop:disable all
      expect(bike2.errors).to be_added(:serial_number, :taken, value: '123')
    end
    it 'ブランドは重複しても、serial_numberが異なれば登録できること' do
      bike1 = Bike.create(@params) # rubocop:disable all
      @params.merge!(serial_number: 456)
      bike2 = Bike.create(@params) # rubocop:disable all
      expect(bike2.valid?).to eq(true)
    end
    it '存在しないブランドIDではは登録できないこと' do
      @params.merge!(brand_id: 999_999)
      bike = Bike.create(@params)
      expect(bike.errors).to be_added(:brand, :blank)
    end
  end

  context 'brand_name が brands テーブルの name に存在しない場合' do
    it '存在しないbrand_idだと登録できないこと #1' do
      bike = Bike.create(brand_id: 1, serial_number: '123')
      expect(bike.errors).to be_added(:brand, :blank)
    end
    it '存在しないbrand_idだと登録できないこと #2' do
      bike = Bike.create(brand_id: 0, serial_number: '123')
      expect(bike.errors).to be_added(:brand, :blank)
    end
  end
end

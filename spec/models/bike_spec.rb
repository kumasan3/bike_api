require 'rails_helper'

RSpec.describe Bike, type: :model do
  context "brand_name が brands テーブルの name に存在する場合" do
    before do
      @brand = Brand.create(name: "YAMAHA")
    end
    it "ブランドIDとシリアルナンバーで登録できること " do
      bike = Bike.create(brand_id: @brand.id, serial_number: "123")
      expect(bike.valid?).to eq(true)
    end
    it "ブランドIDがnilの場合には登録できないこと #1" do
      bike = Bike.create(serial_number: "123")
      expect(bike.errors).to be_added(:brand_id, :blank)
    end
    it "ブランドIDがnilの場合には登録できないこと #2" do
      bike = Bike.create(brand_id: nil, serial_number: "123")
      expect(bike.errors).to be_added(:brand_id, :blank)
    end
    it "シリアルナンバーがnilの場合には登録できないこと #1" do
      bike = Bike.create(brand_id: nil)
      expect(bike.errors).to be_added(:brand, :blank)
    end
    it "シリアルナンバーがnilの場合には登録できないこと #2" do
      bike = Bike.create(brand_id: nil, serial_number: nil)
      expect(bike.errors).to be_added(:brand, :blank)
    end
    it "存在しないブランドIDではは登録できないこと" do
      bike = Bike.create(brand_id: 999999, serial_number: "123")
      expect(bike.errors).to be_added(:brand, :blank)
    end
  end

  context "brand_name が brands テーブルの name に存在しない場合" do

  end

end

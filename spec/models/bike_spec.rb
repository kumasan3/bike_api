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
    it "ブランドIDがnilの場合には登録できないこと" do
      bike = Bike.create(serial_number: "123")
      expect(bike.valid?).to eq(false)
    end
    it "ブランドIDがnilの場合には登録できないこと" do
      bike = Bike.create(brand_id: nil, serial_number: "123")
      expect(bike.valid?).to eq(false)
    end
    it "シリアルナンバーがnilの場合には登録できないこと" do
      bike = Bike.create(brand_id: nil)
      expect(bike.valid?).to eq(false)
    end
    it "シリアルナンバーがnilの場合には登録できないこと" do
      bike = Bike.create(brand_id: nil, serial_number: nil)
      expect(bike.valid?).to eq(false)
    end
    it "存在しないブランドIDではは登録できないこと" do
      bike = Bike.create(brand_id: 50, serial_number: "123")
      expect(bike.errors.full_messages).to eq(false)
    end
  end

end

require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "Brandモデルのテスト" do
    context "新規にブランドを登録する場合" do

      it "新規ブランド名が登録できること" do
        brand = Brand.new(name: "HONDA")
        expect(brand.valid?).to eq(true)
        expect{ brand.save }.to change{ Brand.count }.from(0).to(1)
      end

      it "ブランド名が空だと登録できないこと #1" do
        brand = Brand.create(name: "")
        expect(brand.errors).to be_added(:name, :blank)
      end

      it "ブランド名が空だと登録できないこと #2" do
        brand = Brand.create(name: nil)
        expect(brand.errors).to be_added(:name, :blank)
      end
    end

    context "登録しようとしたブランド名が既存のものと重複する場合" do
      before do
        Brand.create(params)
      end
      let(:params) {{ name: "HONDA"}}
      it "重複するブランド名は登録できないこと2" do
        brand = Brand.create(params)
        expect(brand.errors).to be_added(:name, :taken, value: params[:name])
      end


    end


  end
end

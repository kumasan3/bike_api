require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'Brandモデルの単体テスト' do
    context '新規にブランドを登録するとき' do
      it '新規ブランド名が登録できること' do
        brand = Brand.new(name: 'HONDA')
        expect(brand).to be_valid
        expect { brand.save }.to change { Brand.count }.from(0).to(1)
      end

      it 'ブランド名が空だと登録できないこと #1' do
        brand = Brand.create(name: '')
        expect(brand.errors).to be_added(:name, :blank)
      end

      it 'ブランド名が空だと登録できないこと #2' do
        brand = Brand.create(name: nil)
        expect(brand.errors).to be_added(:name, :blank)
      end
    end

    context '登録しようとしたブランド名が既存のものと重複するとき' do
      let(:params) { { name: 'HONDA' } }
      before do
        Brand.create(params)
      end
      it '重複するブランド名は登録できないこと' do
        brand = Brand.create(params)
        expect(brand.errors).to be_added(:name, :taken, value: params[:name])
      end
    end
  end
end

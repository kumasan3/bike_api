class Bike < ApplicationRecord
  validates :brand_id, presence: true
  validates :serial_number, presence: true, uniqueness: true
  belongs_to :brand
end

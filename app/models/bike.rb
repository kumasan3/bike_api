class Bike < ApplicationRecord
validates :brand_id, presence: true
  validates :serial_number, presence: true, uniqueness: true
  belongs_to :brand

  def set_sold_at
    self.sold_at = DateTime.now
  end
end

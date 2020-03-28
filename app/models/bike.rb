class Bike < ApplicationRecord
validates :brand_id, presence: true
  validates :serial_number, presence: true, uniqueness: true
  belongs_to :brand

  def set_sold_at
    self.sold_at = DateTime.now
  end

  def datetime_to_strftime
    if self.sold_at.is_a?(Time)
      self.sold_at.strftime("%Y年%-m月%-d日 %-H時%-quiM分")
    end
  end

end

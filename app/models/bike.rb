class Bike < ApplicationRecord
    validates :brand_id, presense:true
    validates :serial_number, presense:true, uniqueness: true
    belongs_to :brand
end

class Brand < ApplicationRecord
    validates :name, presense:true, uniqueness: true
end

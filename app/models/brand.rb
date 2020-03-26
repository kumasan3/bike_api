class Brand < ApplicationRecord
    validates :name, presense:true, uniqueness: true
    has_many :bikes
end

class Office < ApplicationRecord
  belongs_to :user, -> { where role: "owner" }
  has_many :cars
end

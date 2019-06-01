class Location < ApplicationRecord
  validates_presence_of :address, :city, :state, :zip
  validates :nickname, presence: true, uniqueness: true

  belongs_to :user
end

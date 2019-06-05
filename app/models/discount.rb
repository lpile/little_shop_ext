class Discount < ApplicationRecord
  validates_presence_of :qualifier, :percentage

  belongs_to :user, foreign_key: 'merchant_id'
end

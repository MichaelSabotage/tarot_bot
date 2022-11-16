class Reading < ApplicationRecord
  belongs_to :topic
  has_many :orders
end

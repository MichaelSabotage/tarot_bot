class Topic < ApplicationRecord
  belongs_to :area
  has_many :readings, dependent: :destroy

  validates :name, presence: true
end

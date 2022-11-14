class User < ApplicationRecord
  validates :first_name, presence: true, length: {minimum: 2}
  validates :phone, presence: true, length: {is: 12}, allow_nil: true
  validates :birth_date, allow_nil: true, date: {after: proc { 100.years.ago },
                                                 before: proc { 14.years.ago }}
  validates :profession, presence: true, allow_nil: true

  def filled?
    unfilled_fields.blank?
  end

  def unfilled_fields
    required_fields = [:first_name, :phone, :birth_date, :profession, :family_status, :children_count]
    required_fields.each_with_object([]) { |elem, result| result << elem if elem.to_proc.call(self).blank? }
  end
end

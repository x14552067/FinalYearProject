class Lecturer < ApplicationRecord
  belongs_to :user
  has_many :classgroups

  def full_name
    return first_name + " " + last_name
  end

end
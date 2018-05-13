class Lecturer < ApplicationRecord
  belongs_to :user
  has_many :classgroups
  has_many :chatmessages
  has_many :answermessages

  validates :first_name, presence: true, length: {minimum: 2}
  validates :last_name, presence: true, length: {minimum: 2}

  def full_name
    return first_name + " " + last_name
  end

end
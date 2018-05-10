class Student < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :classgroups
  has_and_belongs_to_many :classsessions
  has_many :understanding_responses
  has_many :chatmessages
  has_many :questionmessages


  validates :first_name, presence: true, length: {minimum: 2}
  validates :last_name, presence: true, length: {minimum: 2}


  def full_name
    return first_name + " " + last_name
  end

end

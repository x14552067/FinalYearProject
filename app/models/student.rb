class Student < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :classgroups
  belongs_to :classsessions
  has_many :understanding_responses
  has_many :chatmessages

  def full_name
    return first_name + " " + last_name
  end

end

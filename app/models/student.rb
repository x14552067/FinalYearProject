class Student < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :classgroups
  has_many :student_responses
  has_many :chat_messages

end

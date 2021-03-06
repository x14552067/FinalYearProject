class Classsession < ApplicationRecord
  belongs_to :classgroup, dependent: :destroy
  has_many :chatmessages, dependent: :destroy
  has_many :questionmessages, dependent: :destroy
  has_many :answermessages, dependent: :destroy
  has_many :chatmessages
  has_and_belongs_to_many :quizzes
  has_and_belongs_to_many :students
  has_many :understanding_polls
  validates :topic, presence: true
end

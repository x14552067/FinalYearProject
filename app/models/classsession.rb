class Classsession < ApplicationRecord
  belongs_to :classgroup, dependent: :destroy
  has_many :chatmessages, dependent: :destroy
  has_many :questionmessages, dependent: :destroy
  has_many :answermessages, dependent: :destroy
  has_many :chatmessages
  has_many :students
  has_many :understanding_polls
  validates :topic, presence: true
end

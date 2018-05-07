class Classsession < ApplicationRecord
  belongs_to :classgroup, dependent: :destroy
  has_many :chatmessages, dependent: :destroy
  has_many :students, through: :chatmessages
  validates :topic, presence: true, uniqueness: true, case_sensitive: false
end

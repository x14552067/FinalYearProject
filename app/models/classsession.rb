class Classsession < ApplicationRecord
  belongs_to :classgroup, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :students, through: :chat_messages
  validates :topic, presence: true, uniqueness: true, case_sensitive: false
end

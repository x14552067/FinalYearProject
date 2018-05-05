class Classsession < ApplicationRecord
  has_many :chat_messages, dependent: :destroy
  has_many :students, through: :chat_messages
  validates :description, presence: true, uniqueness: true, case_sensitive: false
end

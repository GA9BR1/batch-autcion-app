class Batch < ApplicationRecord
  enum end_status: {
    pending: 0,
    closed: 1,
    canceled: 2
  }
  belongs_to :created_by, class_name: 'User'
  belongs_to :approved_by, class_name: 'User', optional: true
  has_many :items, through: :batch_items
  has_many :batch_items
  has_many :bids
  has_many :doubts
  has_many :users, through: :user_favorite_batches
  validates :start_date, :end_date, :minimum_bid_difference, :minimum_bid, presence: true
  validates :code, uniqueness: true
  before_validation :generate_code, on: :create

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
    letters = ('A'..'Z').to_a.sample(3).join
    numbers = SecureRandom.random_number(100000..999999)
    self.code = "#{letters}-#{numbers}"
  end
end

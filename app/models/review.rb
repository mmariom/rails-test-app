class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :rating, presence: true, inclusion: { in: 1..10 }
  validates :comment, presence: true
end

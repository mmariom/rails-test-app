class Movie < ApplicationRecord

    has_many :reviews, dependent: :destroy

    validates :title, presence: true
    validates :imdb_id, presence: true, uniqueness: true
end

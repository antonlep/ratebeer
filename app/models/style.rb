class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name.to_s
  end

  def self.top(amount)
    Style.all.sort_by(&:average_rating).reverse.take(amount)
  end
end

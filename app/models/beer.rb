class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def avg
    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{brewery.name}, #{name}"
  end
end

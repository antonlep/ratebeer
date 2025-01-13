class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating
    ratings.average(:score)
  end

  def to_s
    brewery.name + ", " + name
  end
end

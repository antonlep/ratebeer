class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.average(:score)
  end
end

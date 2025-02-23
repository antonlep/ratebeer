module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings.empty?
      return 0
    end

    ratings.average(:score)
  end
end

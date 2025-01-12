class Rating < ApplicationRecord
  belongs_to :beer

  def to_s
    beer.name + " " + score.to_s
  end
end

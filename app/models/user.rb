class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\A(?=.*\d)(?=.*[A-Z])+.*\z/,
                                 message: "must contain at least one uppercase letter and one number" }

  def self.most_active(amount)
    User.all.sort_by{ |e| e.ratings.length }.reverse.take(amount)
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if beers.empty?

    grouped_ratings = ratings.group_by { |r| r.beer.style }
    fav_style_from_ratings(grouped_ratings)
  end

  def favorite_brewery
    return nil if beers.empty?

    ratings.first.beer.brewery.name
  end

  def most_active
  end

  private

  def fav_style_from_ratings(grouped_ratings)
    max_avg_rating = 0
    fav_style = grouped_ratings.keys.first
    grouped_ratings.each do |style, ratings|
      avg = ratings.sum(&:score) / ratings.count.to_f
      if avg > max_avg_rating
        max_avg_rating = avg
        fav_style = style
      end
    end
    fav_style
  end
end

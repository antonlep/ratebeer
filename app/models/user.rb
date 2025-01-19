class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4},
            format: { with: /\A(?=.*\d)(?=.*[A-Z])+.*\z/,
            message: "must contain at least one uppercase letter and one number" }
end

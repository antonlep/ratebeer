class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: Date.today.year,
                                   only_integer: true }
  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2025
    puts "changed year to #{year}"
  end
end

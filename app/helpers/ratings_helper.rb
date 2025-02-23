module RatingsHelper
  def round(number)
    number_with_precision(number, precision: 1)
  end
end

class WeatherstackApi
  # def self.places_in(city)
  #   city = city.downcase
  #   places = Rails.cache.read(city)
  #   return places if places
  #
  #   places = get_places_in(city)
  #   Rails.cache.write(city, places, expires_in: 1.week)
  #   places
  # end
  #
  # def self.get_places_in(city)
  #   url = "http://beermapping.com/webservice/loccity/#{key}/"
  #
  #   response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
  #   places = response.parsed_response["bmp_locations"]["location"]
  #
  #   return [] if places.is_a?(Hash) && places['id'].nil?
  #
  #   places = [places] if places.is_a?(Hash)
  #   places.map do |place|
  #     Place.new(place)
  #   end
  # end
  def self.current_weather_in(city)
    city = city.downcase
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{city}"
    response = HTTParty.get url.to_s
    weather = response.parsed_response["current"]

    return [] if weather['success'] == false

    weather
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end

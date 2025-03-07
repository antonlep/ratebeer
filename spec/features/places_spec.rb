require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do

    canned_answer = <<-END_OF_STRING
{"request":{"type":"City","query":"Helsinki, Finland","language":"en","unit":"m"},"location":{"name":"Helsinki","country":"Finland","region":"Southern Finland","lat":"60.176","lon":"24.934","timezone_id":"Europe\/Helsinki","localtime":"2025-02-15 17:50","localtime_epoch":1739641800,"utc_offset":"2.0"},"current":{"observation_time":"03:50 PM","temperature":-7,"weather_code":116,"weather_icons":["https:\/\/cdn.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0004_black_low_cloud.png"],"weather_descriptions":["Partly cloudy"],"wind_speed":19,"wind_degree":4,"wind_dir":"N","pressure":1019,"precip":0,"humidity":73,"cloudcover":25,"feelslike":-14,"uv_index":0,"visibility":10,"is_day":"no"}}
  END_OF_STRING

    stub_request(:get, "http://api.weatherstack.com/current?access_key=&query=kumpula").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: {})

    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, those are shown at the page" do

    canned_answer = <<-END_OF_STRING
{"request":{"type":"City","query":"Helsinki, Finland","language":"en","unit":"m"},"location":{"name":"Helsinki","country":"Finland","region":"Southern Finland","lat":"60.176","lon":"24.934","timezone_id":"Europe\/Helsinki","localtime":"2025-02-15 17:50","localtime_epoch":1739641800,"utc_offset":"2.0"},"current":{"observation_time":"03:50 PM","temperature":-7,"weather_code":116,"weather_icons":["https:\/\/cdn.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0004_black_low_cloud.png"],"weather_descriptions":["Partly cloudy"],"wind_speed":19,"wind_degree":4,"wind_dir":"N","pressure":1019,"precip":0,"humidity":73,"cloudcover":25,"feelslike":-14,"uv_index":0,"visibility":10,"is_day":"no"}}
  END_OF_STRING

    stub_request(:get, "http://api.weatherstack.com/current?access_key=&query=kumpula").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: {})

    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "Vanha mestari", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Vanha mestari"
  end

  it "if none are returned by the API, message is shown" do

    canned_answer = <<-END_OF_STRING
{"request":{"type":"City","query":"Helsinki, Finland","language":"en","unit":"m"},"location":{"name":"Helsinki","country":"Finland","region":"Southern Finland","lat":"60.176","lon":"24.934","timezone_id":"Europe\/Helsinki","localtime":"2025-02-15 17:50","localtime_epoch":1739641800,"utc_offset":"2.0"},"current":{"observation_time":"03:50 PM","temperature":-7,"weather_code":116,"weather_icons":["https:\/\/cdn.worldweatheronline.com\/images\/wsymbols01_png_64\/wsymbol_0004_black_low_cloud.png"],"weather_descriptions":["Partly cloudy"],"wind_speed":19,"wind_degree":4,"wind_dir":"N","pressure":1019,"precip":0,"humidity":73,"cloudcover":25,"feelslike":-14,"uv_index":0,"visibility":10,"is_day":"no"}}
  END_OF_STRING

    stub_request(:get, "http://api.weatherstack.com/current?access_key=&query=kumpula").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: {})

    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    save_page

    expect(page).to have_content "No locations in kumpula"
  end

end
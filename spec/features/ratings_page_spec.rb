require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, score: 5, beer:beer1, user:user }
  let!(:rating2) { FactoryBot.create :rating, score: 10, beer:beer1, user:user }
  let!(:rating3) { FactoryBot.create :rating, score: 20, beer:beer2, user:user }
  let!(:rating4) { FactoryBot.create :rating, score: 25, beer:beer2, user:user }
  let!(:rating5) { FactoryBot.create :rating, score: 30, beer:beer2, user:user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(5).to(6)

    expect(user.ratings.count).to eq(6)
    expect(beer1.ratings.count).to eq(3)
    expect(beer1.average_rating).to eq(10.0)
  end

  it "when multiple ratings exist, those are displayed together with number of ratings" do
    visit ratings_path
    expect(page).to have_content "Number of ratings: 5"
    expect(page).to have_content "Recent ratings"
    expect(page).to have_content "Karhu 30 Pekka"
    expect(page).to have_content "iso 3 10 Pekka"
  end
end
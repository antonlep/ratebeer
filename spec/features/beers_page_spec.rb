require 'rails_helper'

describe "Beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }
  let!(:style) { FactoryBot.create :style, name: "Lager" }
  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end
  it "should be possible to add beer" do
    visit new_beer_path
    fill_in('beer_name', with: 'Koff 4')
    select('Lager', :from => 'beer_style_id')
    select('Koff', :from => 'beer_brewery_id')
    expect {
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)

    expect(page).to have_content 'Beer was successfully created.'
  end

  it "should not be possible to add beer if not valid" do
    visit new_beer_path
    fill_in('beer_name', with: '')
    select('Lager', :from => 'beer_style_id')
    select('Koff', :from => 'beer_brewery_id')
    click_button('Create Beer')
    expect {
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(page).to have_content 'Name is too short'
  end
end

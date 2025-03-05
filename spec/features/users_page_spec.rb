require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
    let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
    let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
    let!(:user1) { FactoryBot.create :user, username: "Mikko" }
    let!(:user2) { FactoryBot.create :user, username: "Kalle" }
    let!(:rating1) { FactoryBot.create :rating, score: 5, beer:beer1, user:user1 }
    let!(:rating2) { FactoryBot.create :rating, score: 10, beer:beer1, user:user2 }
    let!(:rating3) { FactoryBot.create :rating, score: 20, beer:beer2, user:user1 }
    let!(:rating4) { FactoryBot.create :rating, score: 25, beer:beer2, user:user2 }

    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")
      expect(page).to have_content 'Welcome Pekka!'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "can see in their own page their own ratings, but not anyone else's ratings" do
      sign_in(username: "Kalle", password: "Foobar1")
      user = User.find_by_username("Kalle")
      visit user_path(user)
      expect(page).to have_content 'Has made 2 ratings, average rating 17.5'
      expect(page).to have_content 'iso 3 10'
      expect(page).to have_content 'Karhu 25'
      expect(page).not_to have_content 'iso 3 5'
      expect(page).not_to have_content 'Karhu 20'
    end

  end
end
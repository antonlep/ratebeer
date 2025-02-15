require 'rails_helper'

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beer_with_name_style_and_rating(object, name, style, score)
  test_style = FactoryBot.create(:style, name: style)
  beer = FactoryBot.create(:beer, name: name, style: test_style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password with only letters" do
    user = User.create username: "Pekka", password: "secretsecret", password_confirmation: "secretsecret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username: "Pekka", password: "Se1", password_confirmation: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

    describe "favorite beer" do
      let(:user){ FactoryBot.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_beer)
      end

      it "without ratings does not have one" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one rating" do
        beer = FactoryBot.create(:beer)
        rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

        expect(user.favorite_beer).to eq(beer)
      end

      it "is the one with highest rating if several rated" do
        create_beers_with_many_ratings( {user: user}, 10, 15, 9)
        best = create_beer_with_rating({ user: user }, 25 )

        expect(user.favorite_beer).to eq(best)
      end
    end
    describe "favorite style" do
      let(:user){ FactoryBot.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end

      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end

      it "is the only one rated if only one rating" do
        test_style = FactoryBot.create(:style, name: "Lager")
        beer = FactoryBot.create(:beer, style: test_style)
        rating = FactoryBot.create(:rating, beer: beer, user: user)

        expect(user.favorite_style.name).to eq("Lager")
      end

      it "is the one with higher rating if two beers" do
        beer1 = create_beer_with_name_style_and_rating({user: user}, "Koff","Lager", 10)
        beer2 = create_beer_with_name_style_and_rating({user: user}, "Karhu", "Weizen", 20)

        expect(user.favorite_style.name).to eq("Weizen")
      end

      it "is the one with highest average rating if multiple beers" do
        beer1 = create_beer_with_name_style_and_rating({user: user}, "Koff","Lager", 10)
        beer2 = create_beer_with_name_style_and_rating({user: user}, "Karhu", "Weizen", 1)
        beer3 = create_beer_with_name_style_and_rating({user: user}, "Koff2","Lager", 15)
        beer4 = create_beer_with_name_style_and_rating({user: user}, "Karhu2", "Nonalchol", 6)
        beer5 = create_beer_with_name_style_and_rating({user: user}, "Koff3","Weizen", 30)
        beer6 = create_beer_with_name_style_and_rating({user: user}, "Karhu3", "Nonalcohol", 12)

        expect(user.favorite_style.name).to eq("Weizen")
      end
    end
    describe "favorite brewery" do
      let(:user){ FactoryBot.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_brewery)
      end

      it "without ratings does not have one" do
        expect(user.favorite_brewery).to eq(nil)
      end

      it "is the only one rated if only one rating" do
        brewery1 = FactoryBot.create(:brewery, name: "Panimo")
        style1 = FactoryBot.create(:style, name: "Lager")
        beer1 = FactoryBot.create(:beer, style: style1, brewery: brewery1)
        rating1 = FactoryBot.create(:rating, beer: beer1, user: user)

        expect(user.favorite_brewery).to eq("Panimo")
      end

    end
  end
end
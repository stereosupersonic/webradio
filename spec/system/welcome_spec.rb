require "capybara_helper"

describe "welcome", type: :system, js: true do
  it "shows the tranding tracks of this year" do
    create :station, name: "Radio Caroline"

    visit "/"

    expect(page).to have_content("Radio Caroline")
  end
end

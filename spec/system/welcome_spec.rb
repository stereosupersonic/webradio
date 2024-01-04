require "capybara_helper"

describe "welcome", type: :system do
  it "shows the tranding tracks of this year" do
    visit "/"

    expect(page).to have_content("Welcome")
  end
end

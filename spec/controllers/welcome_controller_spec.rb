require "rails_helper"

RSpec.describe WelcomeController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @stations" do
      create(:station)
      get :index
      expect(assigns(:stations)).to be_present
      expect(assigns(:stations).first).to be_a(StationPresenter)
    end

    it "assigns ordered stations" do
      station1 = create(:station, position: 2)
      station2 = create(:station, position: 1)
      get :index
      expect(assigns(:stations).map(&:o)).to eq([station2, station1])
    end
  end
end

require "rails_helper"

RSpec.describe StationsController, type: :controller do
  let(:station) { create(:station) }
  let(:valid_attributes) { { name: "Test Station", url: "http://example.com/stream" } }
  let(:invalid_attributes) { { name: "", url: "" } }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @stations" do
      station
      get :index
      expect(assigns(:stations)).to be_present
      expect(assigns(:stations).first).to be_a(StationPresenter)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: station.to_param }
      expect(response).to be_successful
    end

    it "assigns @station as a presenter" do
      get :show, params: { id: station.to_param }
      expect(assigns(:station)).to be_a(StationPresenter)
      expect(assigns(:station).o).to eq(station)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new station" do
      get :new
      expect(assigns(:station)).to be_a_new(Station)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: station.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Station" do
        expect do
          post :create, params: { station: valid_attributes }
        end.to change(Station, :count).by(1)
      end

      it "redirects to the stations index" do
        post :create, params: { station: valid_attributes }
        expect(response).to redirect_to(stations_url)
      end

      it "calls BrowserInfoUpdater" do
        expect_any_instance_of(BrowserInfoUpdater).to receive(:call)
        post :create, params: { station: valid_attributes }
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { station: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a station" do
        expect do
          post :create, params: { station: invalid_attributes }
        end.not_to change(Station, :count)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Updated Station" } }

      it "updates the requested station" do
        put :update, params: { id: station.to_param, station: new_attributes }
        station.reload
        expect(station.name).to eq("Updated Station")
      end

      it "redirects to the station" do
        put :update, params: { id: station.to_param, station: valid_attributes }
        expect(response).to redirect_to(station_url(station))
      end

      it "calls BrowserInfoUpdater" do
        expect_any_instance_of(BrowserInfoUpdater).to receive(:call)
        put :update, params: { id: station.to_param, station: new_attributes }
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: station.to_param, station: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested station" do
      station
      expect do
        delete :destroy, params: { id: station.to_param }
      end.to change(Station, :count).by(-1)
    end

    it "redirects to the stations list" do
      delete :destroy, params: { id: station.to_param }
      expect(response).to redirect_to(stations_url)
    end
  end
end

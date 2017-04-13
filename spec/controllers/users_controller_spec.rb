require 'rails_helper'
include Capybara::RSpecMatchers

RSpec.describe UsersController, type: :controller do
	render_views

	describe "get 'show'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "devrait reussir" do
			get :show, params: {id: @user}
			expect(response).to have_http_status(:success)
		end

		it "devrait trouver le bon user" do
			get :show, params: {id: @user}
			expect(assigns(:user)).to eq(@user)
		end
	end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

  	it "devrait avoir le bon titre" do
			get :new
			expect(response.body).to have_selector("title", text: "Inscription", visible: false)
  	end 
  end

end

require 'rails_helper'
include Capybara::RSpecMatchers

RSpec.describe PagesController, type: :controller do
	render_views

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "devrait avoir le bon titre" do
      get :home
      expect(response.body).to have_selector('title', text: 'Simple App du Tutoriel Ruby on Rails | Accueil', visible: false)
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get :contact
      expect(response).to have_http_status(:success)
    end

    it "devrait avoir le bon titre" do
      get :contact
      expect(response.body).to have_selector('title', text: 'Simple App du Tutoriel Ruby on Rails | Contact', visible:false)
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end

    it "devrait avoir le bon titre" do
      get :about
      expect(response.body).to have_selector('title', text: 'Simple App du Tutoriel Ruby on Rails | A propos', visible: false)
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
    end
  end

end


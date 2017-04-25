require 'rails_helper'
include Capybara::RSpecMatchers

RSpec.describe PagesController, type: :controller do
    render_views

    before(:each) do
        @base_titre = "Simple App du Tutoriel Ruby on Rails"
    end

    describe "GET home" do
        describe "quand pas identifié" do
            before(:each) do
                get :home
            end

            it "devrait réussir" do
                expect(response).to have_http_status(:success)
            end

            it "devrait avoir le bon titre" do
                expect(response.body).to have_selector('title', text: "#{@base_titre} | Accueil", visible: false)
            end
        end

        describe "quand identifié" do
            before(:each) do
                @user = test_sign_in(FactoryGirl.create(:user))
                other_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
                other_user.follow!(@user)
            end
            
            it "devrait avoir le bon compte d'auteurs et de lecteurs" do
                get :home
                expect(response.body).to have_link("0 auteur suivi", href: following_user_path(@user))
                expect(response.body).to have_link("1 lecteur", href: followers_user_path(@user))
            end
        end
    end

    describe "GET #contact" do
        it "returns http success" do
            get :contact
            expect(response).to have_http_status(:success)
        end

        it "devrait avoir le bon titre" do
            get :contact
            expect(response.body).to have_selector('title', text: "#{@base_titre} | Contact", visible:false)
        end
    end

    describe "GET #about" do
        it "returns http success" do
            get :about
            expect(response).to have_http_status(:success)
        end

        it "devrait avoir le bon titre" do
            get :about
            expect(response.body).to have_selector('title', text: "#{@base_titre} | A propos", visible: false)
        end
    end

    describe "GET #help" do
        it "returns http success" do
            get :help
            expect(response).to have_http_status(:success)
        end
    end
end


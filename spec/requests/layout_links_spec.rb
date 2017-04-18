require 'rails_helper'

RSpec.describe "liens du layout", type: :request do
  describe "GET /layout_links" do
		it "devrait trouver une page accueil a '/'" do
			get '/'
			expect(response).to have_http_status(:success)
		end

    it "devrait trouver une page contact a '/contact'" do
    	get '/contact'
      expect(response).to have_http_status(:success)
    end

    it "devrait trouver une page about a '/about'" do
    	get '/about'
      expect(response).to have_http_status(:success)
    end

    it "devrait trouver une page aide a '/help'" do
    	get '/help'
      expect(response).to have_http_status(:success)
    end

		it "devrait avoir une page d'inscription à '/signup'" do
			get '/signup'
			expect(response).to have_http_status(:success)
		end
  end

	describe "quand pas identifie" do
		it "doit avoir un lien de connection" do
			visit root_path
			expect(page.find_link("S'identifier")[:href]).to eq(signin_path)
		end
	end

	describe "quand identifie" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			visit signin_path
			fill_in "Email", :with => @user.email
			fill_in "Mot de passe", :with => @user.password
			click_button
		end

		it "devrait avoir un lien de deconnection" do
			visit root_path	
			expect(page.find_link("Déconnexion")[:href]).to eq(signout_path)
		end

		it "devrait avoir un lien vers le profil" do
			visit root_path	
			expect(page.find_link("Profil")[:href]).to eq(user_path(@user))
		end
	end

	describe "quand l'utilisateur est administrateur" do
		before(:each) do
			@user = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
			visit signin_path
			fill_in "Email", :with => @user.email
			fill_in "Mot de passe", :with => @user.password
			click_button
		end

		it "devrait y avoir des liens de suppression" do
			visit users_path
			expect(page).to have_link("supprimer")
		end
	end


	describe "quand l'utilisateur n'est pas administrateur" do
		before(:each) do
			@user = FactoryGirl.create(:user, :email => "not_admin@example.com", :admin => false)
      visit signin_path
      fill_in "Email", :with => @user.email
      fill_in "Mot de passe", :with => @user.password
      click_button			
		end

		it "ne devrait pas y avoir des liens de suppression" do
			visit users_path
			expect(page).to_not have_link("supprimer")
		end

	end


end

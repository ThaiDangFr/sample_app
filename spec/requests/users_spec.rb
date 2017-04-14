require 'rails_helper'

describe "Users" do
	describe "une inscription" do

		describe "ratee" do
			it "ne devrait pas creer un nouvel utilisateur" do
				expect(lambda do
					visit signup_path
					fill_in "Nom", :with => ""
					fill_in "Email", :with => ""
					fill_in "Mot de passe", :with => ""
					fill_in "Confirmation mot de passe", :with => ""
					click_button
					expect(page).to have_selector("div#error_explanation")
				end).not_to change(User, :count)
			end
		end

		describe "reussie" do
			it "devrait creer un nouvel utilisateur" do
				expect(lambda do
					visit signup_path
					fill_in "Nom", :with => "Example User"
					fill_in "Email", :with => "user@example.com"
					fill_in "Mot de passe", :with => "foobar"
					fill_in "Confirmation mot de passe", :with => "foobar"
					click_button
					expect(page).to have_selector("div.flash.success", text: "Bienvenue")
				end).to change(User, :count).by(1)
			end
		end

	end

	describe "identification/déconnexion" do
		describe "l'échec" do
			it "ne devrait pas identifier l'utilisateur" do
				visit signin_path
				fill_in "Email", :with => ""
				fill_in "Mot de passe", :with => ""
				click_button
				expect(page).to have_selector("div.flash.error", text: "invalid")
			end
		end

		describe "le succès" do
			it "devrait identifier un utilisateur puis le déconnecter" do
				user = FactoryGirl.create(:user)
				visit signin_path
				fill_in "Email", :with => user.email
				fill_in "Mot de passe", :with => user.password
				click_button
				#expect(controller).to be_signed_in
				expect(page.find_link("Déconnexion")[:href]).to eq(signout_path)
				click_link "Déconnexion"
				expect(page.find_link("S'identifier")[:href]).to eq(signin_path)	
				#expect(controller).not_to be_signed_in
			end
		end

	end

end

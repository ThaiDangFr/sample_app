require 'rails_helper'
include Capybara::RSpecMatchers
include Capybara::DSL

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
					expect(response).to render_template('users/new')
					expect(response.body).to have_selector("div#error_explanation")
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
					expect(response.body).to have_selector("div.flash.success", text: "Bienvenue")
					expect(response).to render_template('users/show')
				end).to change(User, :count).by(1)
			end
		end

	end
end

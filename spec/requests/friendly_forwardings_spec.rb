require 'rails_helper'

RSpec.describe "FriendlyForwardings", type: :request do
#  describe "GET /friendly_forwardings" do
#    it "works! (now write some real specs)" do
#      get friendly_forwardings_path
#      expect(response).to have_http_status(200)
#    end
#  end

	describe "FriendlyForwardings" do
		it "devrait rediriger vers la page voulue après identification" do
			user = FactoryGirl.create(:user)
			visit edit_user_path(user)

			# le test suit automatiquement la redirection vers la page d'identification
			fill_in "Email", :with => user.email
			fill_in "Mot de passe", :with => user.password
			click_button

			# le test suit à nouveau la redirection, cette fois vers users/edit
			#expect(response).to render_template('users/edit')
			expect(page).to have_selector("h1", text: "Edition du profil")
		end
	end

end

require 'rails_helper'

RSpec.describe "LayoutLinks", type: :request do
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


#    it "works! (now write some real specs)" do
#      get layout_links_index_path
#      expect(response).to have_http_status(200)
#    end



  end
end

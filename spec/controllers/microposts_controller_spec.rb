require 'rails_helper'

describe MicropostsController do
    render_views

    describe "contrôle d'accès" do
        it "devrait refuser l'accès pour create" do
            post :create
            expect(response).to redirect_to(signin_path)
        end

        it "devrait refuser l'accès pour destroy" do
            delete :destroy, params: { id:1 }
            expect(response).to redirect_to(signin_path)
        end
    end
end

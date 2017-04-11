require 'rails_helper'

RSpec.describe UsersController, type: :controller do


describe "get 'show'" do
before(:each) do
@user = Factory(:user)
end

it "devrait reussir" do
get :show, :id => @user
expect(response).to have_http_status(:success)
end

it "devrait trouver le bon user" do
get :show, :id => @user
assigns(:user).to == @user
end

end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end

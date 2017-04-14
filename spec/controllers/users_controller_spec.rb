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
			# assigns(:user) <=> @user
			expect(assigns(:user)).to eq(@user)
		end

		it "devrait avoir le bon titre" do
			get :show, params: {id: @user}
			expect(response.body).to have_selector("title", text: @user.nom, visible: false)
		end

		it "devrait inclure le nom de l'utilisateur" do
			get :show, params: {id: @user}
			expect(response.body).to have_selector("h1", text: @user.nom)
		end

		it "devrait avoir une image de profil" do
			get :show, params: {id: @user}
			expect(response.body).to have_selector("h1>img", class: "gravatar")
		end

	end

  describe "GET #new" do
    it "devrait reussir" do
      get :new
      expect(response).to have_http_status(:success)
    end

  	it "devrait avoir le bon titre" do
			get :new
			expect(response.body).to have_selector("title", text: "Inscription", visible: false)
  	end 
	
		it "devrait avoir un champ nom" do
			get :new
			expect(response.body).to have_selector("input[name='user[nom]'][type='text']")
		end

		it "devrait avoir un champ email" do
			get :new
			expect(response.body).to have_selector("input[name='user[email]'][type='text']")
		end

		it "devrait avoir un champ mot de passe" do
			get :new
			expect(response.body).to have_selector("input[name='user[password]'][type='password']")
		end

		it "devrait avoir un champ confirmation du mot de passe" do
			get :new
			expect(response.body).to have_selector("input[name='user[password_confirmation]'][type='password']")
		end

  end

	describe "POST 'create'" do

		describe "echec" do
			before(:each) do
				@attr = { :nom => "", :email => "", :password => "", :password_confirmation => "" }
			end

			it "ne devrait pas creer d'utilisateur" do
				expect(lambda do
					post :create, params: {user: @attr}
				end).not_to change(User, :count)
			end

			it "devrait avoir le bon titre" do
				post :create, params: {user: @attr}
				expect(response.body).to have_selector("title", text: "Inscription", visible: false)
			end

			it "devrait rendre la page 'new'" do
				post :create, params: {user: @attr}
				expect(response).to render_template('new')
			end
		end

		describe "succes" do
			before(:each) do
				@attr = { :nom => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
			end

			it "devrait creer un utilisateur" do
				expect(lambda do
					post :create, params: {user: @attr}
				end).to change(User, :count).by(1)
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				post :create, params: {user: @attr}
				expect(response).to redirect_to(user_path(assigns(:user)))
			end

			it "devrait avoir un message de bienvenue" do
				post :create, params: {user: @attr}
				expect(flash[:success]).to match(/Bienvenue dans l'Application Exemple/i)
			end

			it "devrait identifier l'utilisateur" do
				post :create, :user => @attr
				expect(controller).to be_signed_in
			end
		end
	end




end

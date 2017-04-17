require 'rails_helper'
include Capybara::RSpecMatchers

RSpec.describe UsersController, type: :controller do
	render_views

	describe "get 'index'" do
		describe "pour utilisateur non identifiés" do
			it "devrait refuser l'accès" do
				get :index
				expect(response).to redirect_to(signin_path)
				expect(flash[:notice]).to match(/identifier/i)
			end
		end

		describe "pour un utilisateur identifié" do
			before(:each) do
				@user = test_sign_in(FactoryGirl.create(:user))
				second = FactoryGirl.create(:user, :email => "another@example.com")
				third = FactoryGirl.create(:user, :email => "another@example.net")
				@users = [@user, second, third]
				30.times do
					@users << FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
				end
			end
	
			it "devrait reussir" do
				get :index
				expect(response).to be_success
			end

			it "devrait avoir le bon titre" do
				get :index
				expect(response.body).to have_selector("title", text: "Simple App du Tutoriel Ruby on Rails | Tous les utilisateurs", visible:false)
			end

			it "devrait avoir un élément pour chaque utilisateur" do
				get :index
				@users.each do |user|
					expect(response.body).to have_selector("li", text: user.nom)
				end
			end

			it "devrait avoir un élément pour chaque utilisateur" do
				get :index
				@users[0..2].each do |user|
					expect(response.body).to have_selector("li", :text => user.nom)
				end
			end

			it "devrait paginer les utilisateurs" do
				get :index
				expect(response.body).to have_selector("div.pagination")
				expect(response.body).to have_selector("span.disabled", :text => "Previous")
				expect(response.body).to have_link("2", :href => "/users?page=2")
				expect(response.body).to have_link("Next", :href => "/users?page=2")
			end

		end

	end


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
				post :create, params: {user: @attr}
				expect(controller).to be_signed_in
			end
		end
	end

	describe "GET 'edit'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "devrait reussir" do
			get :edit, params: { id:  @user }
			expect(response).to be_success
		end

		it "devrait avoir le bon titre" do
			get :edit, params: { id: @user }
			expect(response.body).to have_selector("title", text: "Edition profil", visible: false)
		end

		it "devrait avoir un lien pour changer l'image gravatar" do
			get :edit, params: { id: @user}
			gravatar_url = "http://gravatar.com/emails"
			expect(response.body).to have_link("changer", href: gravatar_url)
		end
	end

	describe "PUT 'update'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		describe "Echec" do
			before(:each) do
				@attr = { :email => "", :nom => "", :password => "", :password_confirmation => "" }
			end

			it "devrait retourner la page d'edition" do
				put :update, params: { id: @user, user: @attr }
				expect(response).to render_template('edit')
			end
		end

		describe "Succes" do
			before(:each) do
				@attr = { :nom => "New Name", :email => "user@example.org", :password => "barbaz", :password_confirmation => "barbaz" }
			end

			it "devrait modifier les caracteristiques de l'utilisateur" do
				put :update, params: { id: @user, user: @attr}
				@user.reload
				expect(@user.nom).to eq(@attr[:nom])
				expect(@user.email).to eq(@attr[:email])
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				put :update, params: {id: @user, user: @attr}
				expect(response).to redirect_to(user_path(@user))
			end

			it "devrait afficher un message flash" do
				put :update, params: {id: @user, user: @attr}
				expect(flash[:success]).to match(/actualisé/)
			end
		end
	end

	describe "authentification des pages edit/update" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		describe "pour un utilisateur non identifié" do
			it "devrait refuser l'accès à l'action 'edit'" do
				get :edit, params: {id:@user}
				expect(response).to redirect_to(signin_path)
			end

			it "devrait refuser l'accès à l'action 'update'" do
				put :update, params: {id:@user, user:{}}
				expect(response).to redirect_to(signin_path)
			end
		end

		describe "pour un utilisateur identifié" do
			before(:each) do
				wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
				test_sign_in(wrong_user)
			end

			it "devrait correspondre à l'utilisateur à éditer" do
				get :edit, params:{id:@user}
				expect(response).to redirect_to(root_path)
			end

			it "devrait correspondre à l'utilisateur à actualiser" do
				put :update, params:{id:@user,user:{}}
				expect(response).to redirect_to(root_path)
			end
		end

	end
	
end

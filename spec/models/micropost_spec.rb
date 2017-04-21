require 'rails_helper'

RSpec.describe Micropost, type: :model do
    before(:each) do
        @user = FactoryGirl.create(:user)
        @attr = { :content => "Contenu du message" }
    end

    it "devrait créer instance de micro-message avec bons attributs" do
        @user.microposts.create!(@attr)
    end

    describe "associations avec l'utilisateur" do
        before(:each) do
            @micropost = @user.microposts.create(@attr)
        end

        it "devrait avoir un attribut user" do
            expect(@micropost).to respond_to(:user)
        end

        it "devrait avoir le bon utilisateur associé" do
            expect(@micropost.user_id).to eq(@user.id)
            expect(@micropost.user).to eq(@user)
        end
    end

    describe "validations" do
        it "requiert un identifiant d'utilisateur" do
            expect(Micropost.new(@attr)).to_not be_valid
        end

        it "requiert un contenu non vide" do
            expect(@user.microposts.build(:content => " ")).to_not be_valid
        end

        it "devrait rejeter un contenu trop long" do
            expect(@user.microposts.build(:content => "a" * 141)).to_not be_valid
        end
    end

end
    

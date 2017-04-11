# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nom        :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"

before(:each) do
@attr = { 
:nom => "Example User", 
:email => "user@example.com",
:password => "foobar",
:password_confirmation => "foobar"
}
end

it "devrait creer une nouvelle instance dotee des attributs valides" do
User.create!(@attr)
end

it "exige un nom" do
bad_guy = User.new(@attr.merge(:nom => ""))
expect(bad_guy).not_to be_valid
end

it "exige un email" do
no_email_user = User.new(@attr.merge(:email => ""))
expect(no_email_user).not_to be_valid
end

it "devrait rejeter les noms trop longs" do
long_nom = "a" * 51
long_nom_user = User.new(@attr.merge(:nom => long_nom))
expect(long_nom_user).not_to be_valid
end

it "devrait accepter un email valide" do
addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
addresses.each do |address|
valid_email_user = User.new(@attr.merge(:email => address))
expect(valid_email_user).to be_valid
end
end


it "devrait rejeter un email invalide" do
addresses = %w[user@foo,com user_at_foo_org example.user@foo.]
addresses.each do |address|
invalid_email_user = User.new(@attr.merge(:email => address))
expect(invalid_email_user).not_to be_valid
end
end


it "devrait rejeter un email double" do
# create! : remonte une exception si pas possible
User.create!(@attr)
user_with_dup_email = User.new(@attr)
expect(user_with_dup_email).not_to be_valid
end


it "devrait rejeter un email invalide au niveau de la casse" do
upcased_email = @attr[:email].upcase
User.create!(@attr.merge(:email => upcased_email))
user_with_dup_email = User.new(@attr)
expect(user_with_dup_email).not_to be_valid
end


describe "password validations" do
it "devrait exiger un mot de passe" do
expect(User.new(@attr.merge(:password => "", :passord_confirmation => ""))).not_to be_valid
end

it "devrait exiger une confirmation du mdp" do
expect(User.new(@attr.merge(:password_confirmation => "invalid"))).not_to be_valid
end

it "devrait rejeter les mdp trop courts" do
short = "a" * 5
hash = @attr.merge(:password => short, :password_confirmation => short)
expect(User.new(hash)).not_to be_valid
end

it "devrait rejeter les mdp trop longs" do
long = "a" * 41
hash = @attr.merge(:password => long, :password_confirmation => long)
expect(User.new(hash)).not_to be_valid
end
end



describe "password encryption" do
before(:each) do
@user = User.create!(@attr)
end

it "devrait avoir un mdp crypte" do
expect(@user).to respond_to(:encrypted_password)
end

it "devrait definir le mdp crypte" do
expect(@user.encrypted_password).not_to be_blank
end

describe "methode has_password?" do
it "doit retourner true si les mdp coincident" do
expect(@user.has_password?(@attr[:password])).to be true
end

it "doit retourner false si les mdp divergent" do
expect(@user.has_password?("invalide")).to be false
end

describe "authenticate method" do
it "devrait retourner nul si email mdp ne correspondent pas" do
wrong_password_user = User.authenticate(@attr[:email],"wrongpass")
expect(wrong_password_user).to be_nil
end

it "devrait retourner nil qd un email ne correspond a personne" do
nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
expect(nonexistent_user).to be_nil
end

it "devrait retourner le user si authent ok" do
matching_user = User.authenticate(@attr[:email],@attr[:password])
expect(matching_user).to == @user
end

end


end


end




end

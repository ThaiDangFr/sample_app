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
@attr = { :nom => "Example User", :email => "user@example.com" }
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



end

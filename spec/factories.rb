# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
	factory :user do
	  nom                   "Michael Hartl"
	  email                 "mhartl@example.com"
	  password              "foobar"
	  password_confirmation "foobar"
	end

	sequence :email do |n|
		"person-#{n}@example.com"
	end
end

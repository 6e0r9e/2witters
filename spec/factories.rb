FactoryGirl.define do
  factory :user do
    name 'George Rodriguez'
    email 'georgecrodriguez@gmail.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
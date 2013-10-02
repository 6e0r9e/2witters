require 'spec_helper'

describe "User Pages" do
 subject {page}

 shared_examples_for "All user pages" do
   it { should have_selector('h1', text: heading) }
   it { should have_title(full_title(page_title)) }
 end

 describe "Signup page" do
  before { visit signup_path}
  let(:heading) {'Sign up'}
  let(:page_title) {'Sign up'}
  let(:submit) {"Create my account"}
  it_should_behave_like "All user pages"

   describe "With valid information" do
     it "Should not create a user" do
       expect {click_button submit}.not_to change(User, :count)
     end
   end

   describe "With valid infomation" do
     let(:user) {FactoryGirl.create(:user)}
     before do
       fill_in "Name",         with: "Example User"
       fill_in "Email",        with: "user@example.com"
       fill_in "Password",     with: "foobar"
       fill_in "Confirmation", with: "foobar"
     end
     it "Should create a user" do
       expect {click_button submit}.to change(User, :count).by(1)
     end
   end
 end

 describe "Sign in" do
   before { visit signin_path }
   let(:heading) {'Sign in'}
   let(:page_title) {'Sign in'}
   it_should_behave_like "All user pages"
 end

 describe "Profile page" do
   let(:user) { FactoryGirl.create(:user)}
   before {visit user_path(user)}
   it {should have_content(user.name)}
   it {should have_title(user.name)}
 end
end

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
  it_should_behave_like "All user pages"
 end

 describe "Sign in" do
   before { visit signin_path }
   let(:heading) {'Sign in'}
   let(:page_title) {'Sign in'}
   it_should_behave_like "All user pages"
 end

 describe "Profile page" do
   before {visit user_path(user)}
   it {should have_content(user.name)}
   it {should have_title(user.name)}
 end
end

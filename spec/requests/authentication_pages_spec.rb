require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "Signin page" do
    before { visit signin_path}
    it {should have_content('Sign in')}
    it {should have_title('Sign in')}

    describe "Invalid sign in credentials" do
      before {click_button "Sign in"}
      it {should have_title('Sign in')}
      it {should have_selector('div.alert.alert-error', text: 'Invalid')}
    end

    describe "Valid sign in credentials" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        fill_in
      end

    end
  end
end

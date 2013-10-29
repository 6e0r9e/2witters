require 'spec_helper'


describe User do
  before do
    @user = User.new(name: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
  end

  subject { @user}

  it { should respond_to(:name) }
  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:admin)}
  it { should respond_to(:microposts)}
  it { should respond_to(:feed)}
  it { should respond_to(:relationships)}
  it { should respond_to(:followed_user)}
  it { should respond_to(:reverse_relationships)}
  it { should respond_to(:followers)}
  it { should respond_to(:following?)}
  it { should respond_to(:follow!)}
  it { should respond_to(:unfollow!)}
  it { should be_valid }
  it { should_not be_admin}

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
      it { should be_admin}
  end

  describe 'When name is not present' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'When email is not present' do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe 'When name is to long' do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'When email format is valid' do
    it 'Should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.1st@foo.jp a+b@baz.cn george@gmail.com]
      addresses.each do |valid_address|
       @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe 'When email format is invalid' do
    it 'Should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
       @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'When email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe 'When email has a mixed case' do
    let(:mixed_case_email) {'Foo@ExAMPle.CoM'}
    it 'Should be saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe 'When password is not present' do
    before do
      @user = User.new(name: 'Example User', email:'user@example.com', password:' ', password_confirmation:' ')
    end
      it { should_not be_valid}
  end

  describe 'When users passwords dont match' do
    before {@user.password_confirmation = 'mismatch'}
    it { should_not be_valid}
  end

  describe 'When a password is too short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  describe 'Return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email)}

    describe 'With valid password' do
      it { should eq found_user.authenticate(@user.password)}
    end

    describe 'With invalid password' do
      let(:user_invalid_password) { found_user.authenticate('Invalid')}
      it { should_not eq user_invalid_password }
      specify { expect(user_invalid_password).to be_false }
    end
  end

  describe 'Remember token' do
    before { @user.save }
    its(:remember_token) {should_not be_blank}
  end

  describe "micropost associations" do
    before {@user.save}
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) {should include(newer_micropost)}
      its(:feed) {should include(older_micropost)}
      its(:feed) {should_not include(unfollowed_post)}
    end
  end

  describe "following" do
    let(:other_user) {FactoryGirl.create(:user)}
    before do
      @user.save
      @user.follow!(other_user)
    end

    it {should be_following(other_user)}
    its(:followed_users) {should include(other_user)}

    describe "and unfollowing" do
      before { @user.follow!(other_user)}

      it {should_not be_following(other_user)}
      its(:followed_users) { should_not include(other_user)}
    end

    describe "followed_user" do
      subject { other_user }
      its(:followers) { should include(@user)}
    end
  end
end

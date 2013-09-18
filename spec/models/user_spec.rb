require 'spec_helper'


describe User do
  before do
    @user = User.new(name:"Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user}

  it { should respond_to(:name) }
  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}
  it { should be_valid }

  describe "When name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "When email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "When name is to long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "When email format is valid" do
    it "Should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.1st@foo.jp a+b@baz.cn george@gmail.com]
      addresses.each do |valid_address|
       @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "When email format is invalid" do
    it "Should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
       @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "When email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "When email has a mixed case" do
    let(:mixed_case_email) {'Foo@ExAMPle.CoM'}
    it "Should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "When password is not present" do
    before do
      @user = User.new(name:"Example User", email:'user@example.com', password:' ', password_confirmation:' ')
    end
      it { should_not be_valid}
  end

  describe "When users passwords dont match" do
    before {@user.password_confirmation = 'mismatch'}
    it { should_not be_valid}
  end

  describe "When a password is too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  describe "Return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email)}

    describe "With valid password" do
      it { should eq found_user.authenticate(@user.password)}
    end

    describe "With invalid password" do
      let(:user_invalid_password) { found_user.authenticate("Invalid")}
      it { should_not eq user_invalid_password }
      specify { expect(user_invalid_password).to be_false }
    end
  end
end

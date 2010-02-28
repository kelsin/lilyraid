require 'spec_helper'

describe Account do
  before(:each) do
    @valid_attributes = {
      :name => "Test",
      :email => "test@test.com"
    }
  end

  it "should create a new instance given valid attributes" do
    Account.create!(@valid_attributes)
  end

  describe "with normal attributes" do
    before(:each) do
      @account = Account.create!(@valid_attributes)
      @raid = Raid.create
    end

    it "should fail to be destroyed if can_delete? = false" do
      @account.should_receive(:can_delete?).once.and_return(false)
      @account.destroy.should == false
    end

    it "should be able to be deleted while it has no characters" do
      @account.can_delete?.should == true
    end

    describe "with a raid" do
      before(:each) do
        @account.raids.create
      end

      it "should be able to edit a raid it created" do
        @account.can_edit?(@account.raids.first).should == true
      end

      it "shouldn't be able to edit a raid it didn't create" do
        @account.can_edit?(@raid).should == false
      end
    end

    describe "an admin" do
      before(:each) do
        @account.update_attribute(:admin, true)
      end

      it "should be able to edit any raid" do
        @raid = Raid.new

        @account.can_edit?(@raid).should == true
      end
    end

    describe "with a character" do
      before(:each) do
        @character = Character.new(:name => "test character")
        @account.characters << @character
      end

      it "should not be able to be deleted if the character can't" do
        @character.should_receive(:can_delete?).once.and_return(false)

        @account.can_delete?.should == false
      end

      it "should be able to be deleted if the character can" do
        @character.should_receive(:can_delete?).once.and_return(true)

        @account.can_delete?.should == true
      end
    end
  end
end

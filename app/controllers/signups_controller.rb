class SignupsController < ApplicationController
  before_filter(:load_raid, :only => [:create, :destroy, :preferred, :update])
  before_filter(:load_signup, :only => [:destroy, :preferred, :update])

  def create
    @signup = Signup.new(params[:signup])
    @signup.raid = @raid

    authorize! :create, @signup
    @signup.save

    signup_log(@signup, "New signup")

    respond_to do |format|
      format.html { redirect_to raid_url(@raid) }
    end
  end

  def destroy
    authorize! :destroy, @signup
    @signup.destroy

    # Handle preferred settings if there is one signup left
    if @signup.raid.signups.from_account(@signup.character.account).count == 1
      @signup.raid.signups.from_account(@signup.character.account).each do |signup|
        signup.preferred = false
        signup.save
      end
    end

    signup_log(@signup, "Removed signup")

    respond_to do |format|
      format.html { redirect_to raid_url(@raid) }
    end
  end

  def update
    @signup.update_attributes(params[:signup])

    redirect_to @raid
  end

  def preferred
    @signup.preferred = ! @signup.preferred
    @signup.save

    redirect_to raid_url(@signup.raid)
  end

  private

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end

  def load_signup
    @signup = @raid.signups.find(params[:id])
  end
end

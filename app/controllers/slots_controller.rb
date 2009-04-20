class SlotsController < ApplicationController
  before_filter(:load_raid)
  before_filter(:load_slots, :only => [:index])
  before_filter(:load_slot, :only => [:edit, :destroy, :update])

  def index
    respond_to do |format|
      format.html
      format.xml { render :xml => @slots.to_xml }
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @current_account.can_edit(@raid)
      if params[:from_slot_id]
        @signup = nil
        @from_slot = @raid.slots.find(params[:from_slot_id])

        if @slot.accept(@from_slot.signup)
          @slot.signup = @from_slot.signup
          @from_slot.signup = nil
          @from_slot.save
          @slot.save
          @signup = nil
        else
          others = @from_slot.signup.other_signups.select do |other_signup|
            @slot.accept(other_signup)
          end

          if others.size > 0
            @slot.signup = others[0]
            @from_slot.signup = nil
            @from_slot.save
            @slot.save
            @signup = nil
          end
        end
      elsif params[:from_signup_id]
        @signup = @raid.signups.find(params[:from_signup_id])
        @from_slot = nil

        if @slot.accept(@signup)
          @slot.signup = @signup
          @slot.save
          @from_slot = nil
        end
      end
      
      @raid.reload

      load_list

      respond_to do |format|
        format.html { redirect_to raid_url(@raid) }
        format.js { render :template => false }
        format.xml { render :xml => @slot.to_xml }
      end
    end
  end

  def destroy
    @signup = @slot.signup
    @slot.signup = nil
    @slot.save

    load_list
    
    respond_to do |format|
      format.html { redirect_to raid_url(@raid) }
      format.js { render :template => false }
    end
  end

  private

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end

  def load_list
    @list = List.get_list_from_raid("Master", @raid)
  end

  def load_slots
    @slots = @raid.slots.find(:all, :order => :name)
  end

  def load_slot
    @slot = @raid.slots.find(params[:id])
  end
end

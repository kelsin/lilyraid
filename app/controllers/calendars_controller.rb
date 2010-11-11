class CalendarsController < ApplicationController
  include Icalendar

  skip_before_filter :authorize
  skip_before_filter :fake_authorize

  def show
    respond_to do |format|
      format.html
      format.ics do
        render :text => calendar, :content_type => 'text/calendar'
      end
    end
  end

  private

  def calendar(account = nil)
    cal = Calendar.new
    cal.custom_property("METHOD", "PUBLISH")
    cal.custom_property("X-WR-CALNAME", CONFIG[:guild] + " Raid Calendar")
    cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")

    cal.custom_property("X-WR-CALDESC", if account
                                          "Raid schedule for #{@account.name} of the " + CONFIG[:guild] + " Warcraft Guild"
                                        else
                                          "Raid schedule for the " + CONFIG[:guild] + " Warcraft Guild"
                                        end)

    cal.timezone do
      timezone_id "America/Los_Angeles"

      daylight do
        timezone_offset_from "-0800"
        timezone_offset_to "-0700"
        timezone_name "PDT"
        dtstart "19700308TO20000"
        add_recurrence_rule "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
      end

      standard do
        timezone_offset_from "-0700"
        timezone_offset_to "-0800"
        timezone_name "PST"
        dtstart "19701101T020000"
        add_recurrence_rule "YEARLY;BYMONTH=11;BYDAY=1SU"
      end
    end

    Raid.find(:all, :order => :date).each do |raid|
      cal.add_event event(raid)
    end
  end

  def event(raid)
    event = Event.new

    event.dtstart = raid.date
    event.dtend = raid.date.advance(:hours => 3)
    event.description = raid.note
    event.location = "Bronzebeard World of Warcraft Server"
    event.organizer = raid.account.name if raid.account
    event.summary = raid.name
    event.klass = "PUBLIC"
    event.uid = raid.uid
    event.url = url_for(raid)

    raid.confirmed_characters.each do |character|
      event.add_attendee character.name
    end

    return event
  end
end
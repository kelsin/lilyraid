class CalendarsController < ApplicationController
  include Icalendar

  skip_authorization_check
  skip_before_filter :authorize

  def show
    @current_account = Account.find_by_id(session[:account_id])

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
        dtstart "19700308T020000"
        add_recurrence_rule "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
      end

      standard do
        timezone_offset_from "-0700"
        timezone_offset_to "-0800"
        timezone_name "PST"
        dtstart "19701101T020000"
        add_recurrence_rule "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
      end
    end

    Raid.where('date >= ?', DateTime.now - 1.month).order('date').each do |raid|
      cal.add_event event(raid)
    end

    cal.publish
    return cal.to_ical
  end

  def event(raid)
    event = Event.new

    event.dtstart = raid.date.strftime('%Y%m%dT%H%M%S')
    event.dtend = raid.date.advance(:hours => 3).strftime('%Y%m%dT%H%M%S')
    event.description = raid.note
    event.location = "Bronzebeard World of Warcraft Server"
    event.organizer = raid.account.name if raid.account
    event.summary = raid.name
    event.klass = "PUBLIC"
    event.uid = raid.uid
    event.url = url_for(raid)

    # raid.confirmed_characters.each do |character|
    #   event.add_attendee character.name
    # end

    return event
  end
end

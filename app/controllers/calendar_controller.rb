class CalendarController < ApplicationController
  skip_before_filter :authorize, :except => :index
  skip_before_filter :fake_authorize, :except => :index

  before_filter :load_calendar, :only => [:raids, :account]

  def raids
    @cal.custom_property("X-WR-CALDESC", "Raid schedule for the " + CONFIG[:guild] + " Warcraft Guild")

    Raid.find(:all, :order => :date).each do |raid|
      if raid.date
        rurl = raid_url(raid)
        @cal.event do
          dtstart raid.date.strftime("%Y%m%dT%H%M%S")
          dtend raid.date.advance(:hours => 3).strftime("%Y%m%dT%H%M%S")
          duration 'PT3H'
          url rurl
          location "Bronzebeard World of Warcraft Server"
          organizer raid.account.name if raid.account
          summary raid.name
          description raid.note
          klass "PUBLIC"
          uid raid.uid
        end
      end
    end

    send_data(@cal.to_ical,
              :filename => "raids.ics",
              :type => "text/calendar")
  end

  def account
    @account = Account.find(params[:id])
    @cal.custom_property("X-WR-CALDESC", "Raid schedule for #{@account.name} of the " + CONFIG[:guild] + " Warcraft Guild")

    @account.signups.map do |signup|
      signup.raid
    end.each do |raid|
      if raid.date
        rurl = raid_url(raid)
        @cal.event do
          dtstart raid.date.strftime("%Y%m%dT%H%M%S")
          dtend raid.date.advance(:hours => 3).strftime("%Y%m%dT%H%M%S")
          duration 'PT3H'
          url rurl
          location "Bronzebeard World of Warcraft Server"
          organizer raid.account.name if raid.account
          summary raid.name
          description raid.note
          klass "PUBLIC"
          uid raid.uid
        end
      end
    end

    send_data(@cal.to_ical,
              :filename => "#{@account.name}.ics",
              :type => "text/calendar")
  end

  private

  def load_calendar
    @cal = Icalendar::Calendar.new
    @cal.custom_property("METHOD", "PUBLISH")
    @cal.custom_property("X-WR-CALNAME", CONFIG[:guild] + " Raid Calendar")
    @cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")

    @cal.timezone do
      timezone_id             "America/Los_Angeles"

      daylight do
        timezone_offset_from  "-0800"
        timezone_offset_to    "-0700"
        timezone_name         "PDT"
        dtstart               "19700308TO20000"
        add_recurrence_rule   "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
      end

      standard do
        timezone_offset_from  "-0700"
        timezone_offset_to    "-0800"
        timezone_name         "PST"
        dtstart               "19701101T020000"
        add_recurrence_rule   "YEARLY;BYMONTH=11;BYDAY=1SU"
      end
    end
  end
end

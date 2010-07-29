class CalendarController < ApplicationController
  skip_before_filter :authorize, :except => :index

  def raids
    cal = Icalendar::Calendar.new

    cal.custom_property("METHOD", "PUBLISH")
    cal.custom_property("X-WR-CALNAME", CONFIG[:guild] + " Raid Calendar")
    cal.custom_property("X-WR-CALDESC", "Raid schedule for the " + CONFIG[:guild] + " Warcraft Guild")
    cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")

    # cal.add_component(get_tz)

    Raid.find(:all, :order => :date).each do |raid|
      if raid.date
        params = { "TZID" => ["America/Los_Angeles"] }
        rurl = raid_url(raid)
        cal.event do
          dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
          duration 'PT4H'
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

    send_data(cal.to_ical,
              :filename => "raids.ics",
              :type => "text/calendar")
  end

  def account
    cal = Icalendar::Calendar.new

    @account = Account.find(params[:id])

    cal.custom_property("METHOD", "PUBLISH")
    cal.custom_property("X-WR-CALNAME", CONFIG[:guild] + " Raid Calendar for #{@account.name}")
    cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")
    cal.custom_property("X-WR-CALDESC", "Raid schedule for #{@account.name} of the " + CONFIG[:guild] + " Warcraft Guild")

    cal.add_component(get_tz)

    @account.all_raid_signups.each do |raid|
      if raid.date
        params = { "TZID" => ["America/Los_Angeles"] }
        rurl = raid_url(raid)
        cal.event do
          dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
          duration 'PT4H'
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

    send_data(cal.to_ical,
              :filename => "#{@account.name}.ics",
              :type => "text/calendar")
  end

  private

  def get_tz
    tz = Icalendar::Timezone.new
    tz.tzid = "America/Los_Angeles"
    tz.custom_property("X-LIC-LOCATION", "America/Los_Angeles")
    daylight = Icalendar::Daylight.new
    daylight.tzoffsetfrom = "-0800"
    daylight.tzoffsetto = "-0700"
    daylight.tzname = "PDT"
    daylight.dtstart = "19700308T020000"
    daylight.add_rrule "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
    tz.add_component(daylight)
    stan = Icalendar::Standard.new
    stan.tzoffsetfrom = "-0700"
    stan.tzoffsetto = "-0800"
    stan.tzname = "PST"
    stan.dtstart = "19701101T020000"
    stan.add_rrule "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
    tz.add_component(stan)
    return tz
  end
end

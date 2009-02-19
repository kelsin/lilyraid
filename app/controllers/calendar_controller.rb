class CalendarController < ApplicationController
    skip_before_filter :authorize, :except => :index

    def raids
        cal = Icalendar::Calendar.new

        cal.custom_property("METHOD", "PUBLISH")
        cal.custom_property("X-WR-CALNAME", "CoD Raid Calendar")
        cal.custom_property("X-WR-CALDESC", "Raid schedule for the Cake or Death Warcraft Guild")
        cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")

        cal.add_component(get_tz)

        Raid.find(:all, :order => :date).each do |raid|
            event = Icalendar::Event.new
            params = { "TZID" => ["America/Los_Angeles"] }
            if raid.date
                event.dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
                event.dtend = raid.date.advance(:hours => 4).strftime("%Y%m%dT%H%M%S")
            end
            event.url = raid_url(raid)
            event.location = "Bronzebeard World of Warcraft Server"
            event.organizer = raid.account.name if raid.account
            event.summary = raid.name
            event.description = raid.note
            event.klass = "PUBLIC"
            event.uid = raid.uid
            cal.add_event(event)
        end

        send_data(cal.to_ical,
                  :filename => "raids.ics",
                  :type => "text/calendar")
    end

    def account
        cal = Icalendar::Calendar.new

        @account = Account.find(params[:id])

        cal.custom_property("METHOD", "PUBLISH")
        cal.custom_property("X-WR-CALNAME", "CoD Raid Calendar for #{@account.name}")
        cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")
        cal.custom_property("X-WR-CALDESC", "Raid schedule for #{@account.name} of the Cake or Death Warcraft Guild")

        cal.add_component(get_tz)
        
        @account.all_raid_signups.each do |raid|
            character = raid.find_signup(@account).character.name

            status = if raid.find_character(character)
                         " in the raid."
                     else
                         " in the waiting list."
                     end

            event = Icalendar::Event.new
            params = { "TZID" => ["America/Los_Angeles"] }
            if raid.date
                event.dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
                event.dtend = raid.date.advance(:hours => 4).strftime("%Y%m%dT%H%M%S")
            end
            event.url = raid_url(raid)
            event.location = "Bronzebeard World of Warcraft Server"
            event.organizer = raid.account.name if raid.account
            event.summary = raid.name
            event.add_attendee "#{character}#{status}"
            event.description = raid.note
            event.klass = "PUBLIC"
            event.uid = raid.uid
            cal.add_event(event)
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

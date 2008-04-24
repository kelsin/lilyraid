class CalendarController < ApplicationController
    skip_before_filter :authorize, :except => :index

    def raids
        cal = Icalendar::Calendar.new

        cal.custom_property("METHOD", "PUBLISH")
        cal.custom_property("X-WR-CALNAME", "DotA Raid Calendar")
        cal.custom_property("X-WR-CALDESC", "Raid schedule for the Daughters of the Alliance Warcraft Guild")
        cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")

        cal.add_component(get_tz)

        Raid.find(:all, :order => :date).each do |raid|
            event = Event.new
            params = { "TZID" => ["America/Los_Angeles"] }
            event.dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
            event.dtend = raid.date.advance(:hours => 4).strftime("%Y%m%dT%H%M%S")
            event.url = "http://raids.dota-guild.com/raids/#{raid.id}"
            event.location = "Bronzebeard World of Warcraft Server"
            event.organizer = raid.account.name
            event.summary = raid.name
            event.description = raid.notes
            event.klass = "PUBLIC"
            event.uid = "raid_#{raid.id}@raids.dota-guild.com"
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
        cal.custom_property("X-WR-CALNAME", "DotA Raid Calendar for #{@account.name}")
        cal.custom_property("X-WR-TIMEZONE", "America/Los_Angeles")
        cal.custom_property("X-WR-CALDESC", "Raid schedule for #{@account.name} of the Daughters of the Alliance Warcraft Guild")

        cal.add_component(get_tz)
        
        @account.all_raid_signups.each do |raid|
            character = raid.find_signup(@account).character.name

            status = if raid.find_character(character)
                         " in the raid."
                     else
                         " in the waiting list."
                     end

            event = Event.new
            params = { "TZID" => ["America/Los_Angeles"] }
            event.dtstart raid.date.strftime("%Y%m%dT%H%M%S"), params
            event.dtend = raid.date.advance(:hours => 4).strftime("%Y%m%dT%H%M%S")
            event.url = "http://raids.dota-guild.com/raids/#{raid.id}"
            event.location = "Bronzebeard World of Warcraft Server"
            event.organizer = raid.account.name
            event.summary = raid.name
            event.add_attendee "#{character}#{status}"
            event.description = raid.notes
            event.klass = "PUBLIC"
            event.uid = "raid_#{raid.id}@raids.dota-guild.com"
            cal.add_event(event)
        end

        send_data(cal.to_ical,
                  :filename => "#{@account.name}.ics",
                  :type => "text/calendar")
    end            

    private

    def get_tz
        tz = Timezone.new
        tz.tzid = "America/Los_Angeles"
        tz.custom_property("X-LIC-LOCATION", "America/Los_Angeles")
        daylight = Daylight.new
        daylight.tzoffsetfrom = "-0800"
        daylight.tzoffsetto = "-0700"
        daylight.tzname = "PDT"
        daylight.dtstart = "19700308T020000"
        daylight.add_rrule "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
        tz.add_component(daylight)
        stan = Standard.new
        stan.tzoffsetfrom = "-0700"
        stan.tzoffsetto = "-0800"
        stan.tzname = "PST"
        stan.dtstart = "19701101T020000"
        stan.add_rrule "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
        tz.add_component(stan)
        return tz
    end        
end

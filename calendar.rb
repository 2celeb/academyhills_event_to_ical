# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'icalendar'
require 'nokogiri'
require 'open-uri'


TZ = 'Asia/Tokyo'

get '/' do
  'アカデミーヒルズのグーグルカレンダーです'
end


get '/ical' do




  d = Date.today
  events = []
  current_url = d.strftime("%B").downcase + ".html"

  month = Date.today.year
  url = "http://www.academyhills.com/library/calendar/#{month}/#{current_url}"


  c = Icalendar::Calendar.new
  tz = Icalendar::Timezone.new
  tz.timezone_id = TZ

=begin
  standard = Icalendar::Standard.new
  standard.timezone_offset_from =   "+0900"
  standard.timezone_offset_to =     "+1000"
  standard.timezone_name =          "JST"
  standard.dtstart =                "19700101T000000"


  tz.add(standard)
  c.add(tz)
=end

  Nokogiri.HTML(open(url), nil, 'utf-8').search("//div[@class='calendarModule']/table/tr").each do |tr|

    day = tr.search("th").first.inner_text.split('(')[0].to_i

    tr.search("td/ul/li").each do |text|

      title = text.inner_text.gsub(/--|[\r\t\n■◇]/,'').strip.chomp

      next if text  == ""
      title = title.gsub(/\((\d+:\d+)～(\d+:\d+)\D*\)/,'') + "!"
      klass = text.search("span[@class='biz label']").first.inner_text.to_s rescue ""
      times = text.to_s.scan(/(\d+:\d+)～(\d+:\d+)/)

      if times[0]
        start_time = times[0][0].split(":")
        end_time = times[0][1].split(":")

        e = Icalendar::Event.new
        e.dtstart = DateTime.new(d.year,d.month,day,start_time[0].to_i,start_time[1].to_i)
        e.dtend = DateTime.new(d.year,d.month,day,end_time[0].to_i,end_time[1].to_i)
        e.last_modified = DateTime.now
        e.summary = title
        c.add_event(e)
      end
    end
  end
  output = ""
  c.to_ical.lines do|l|
#      "#{$1}#{$2}Z"
#    l = l.gsub(/(DTEND|DTSTART)(:\d+T\d+)/) do |date|

#      "#{$1};TZID=Asia/Tokyo#{$2}"
#    end
    output += l unless /^\s/ =~ l

  end
  output

end

# -*- coding: utf-8 -*-

require 'icalendar'
require 'nokogiri'
require 'open-uri'

class Event

  TZ = 'Asia/Tokyo'
  attr :crawl_urls

  def initialize(year,month)
    @date = Date.new(year,month,1) << 4

    crawl_months = []
    6.times {|i| crawl_months << (@date >> i)}

    @crawl_urls = []
    crawl_months.each do |date|
      url = "http://www.academyhills.com/library/calendar/#{date.year}/#{date.strftime("%B").downcase}.html"
      @crawl_urls << {:year => date.year,:month => date.month,:url => url}
    end
  end


  def events
    return @calendar_events if @calendar_events
    @calendar_events = []
    @crawl_urls.each do |task|

      events = Nokogiri.HTML(open(task[:url]), nil, 'utf-8').search("//div[@class='calendarModule']/table/tr")
      events.each do |tr|
        day = tr.search("th").first.inner_text.split('(')[0].to_i

        tr.search("td/ul/li").each do |text|

          title = text.inner_text.gsub(/--|[\r\t\n■◇]/,'').strip.chomp

          next if text  == ""
          title = title.gsub(/\((\d+:\d+)～(\d+:\d+)\D*\)/,'') + "!"
          klass = text.search("span[@class='biz label']").first.inner_text.to_s rescue ""
          times = text.to_s.scan(/(\d+[:：]\d+)\s*～\s*(\d+[:：]\d+)/)

          if times[0]
            # 時間指定が有るイベント
            start_time = times[0][0].split(":")
            end_time = times[0][1].split(":")
            e = Icalendar::Event.new
            e.dtstart = DateTime.new(task[:year],task[:month],day,start_time[0].to_i,start_time[1].to_i)
            e.dtend = DateTime.new(task[:year],task[:month],day,end_time[0].to_i,end_time[1].to_i)
            e.last_modified = DateTime.now
            e.summary = title

          else
            # 時間指定を検出できないイベント
            e = Icalendar::Event.new
            e.dtstart = Date.new(task[:year],task[:month],day)
            e.dtend = Date.new(task[:year],task[:month],day) + 1
            e.last_modified = DateTime.now
            e.summary = title
          end
          @calendar_events << e
        end
      end
    end
    @calendar_events
  end

  def to_ical

    c = Icalendar::Calendar.new
    tz = Icalendar::Timezone.new
    tz.timezone_id = TZ

    standard = Icalendar::Standard.new
    standard.timezone_offset_from =   "+0900"
    standard.timezone_offset_to =     "+1000"
    standard.timezone_name =          "JST"
    standard.dtstart =                "19700101T000000"

    tz.add(standard)
    c.add(tz)

    events.each do |event|
      c.add_event(event)
    end

    output = ""
    c.to_ical.lines do|l|

      l = l.gsub(/(DTEND|DTSTART)(:\d+T\d+)/) do |date|
        "#{$1};TZID=Asia/Tokyo#{$2}"
      end
      output += l unless /^\s/ =~ l

    end
    output
  end

end

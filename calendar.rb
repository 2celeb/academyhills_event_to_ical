# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'icalendar'
require 'nokogiri'
require 'open-uri'
require 'active_support'
require File.dirname(__FILE__) + '/event.rb'


get '/' do
  'アカデミーヒルズのグーグルカレンダーです'
end


get '/ical3' do

  d = Date.today
  e = Event.new(d.year,d.month)
  e.to_ical

end

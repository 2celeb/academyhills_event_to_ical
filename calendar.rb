# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'icalendar'
require 'nokogiri'
require 'open-uri'
require 'active_support'
require 'haml'

require File.dirname(__FILE__) + '/event.rb'


get '/' do
  haml :index
end


get '/academyhills.ical' do

  cache_control :public, :max_age => 36000
  d = Date.today
  e = Event.new(d.year,d.month)
  e.to_ical

end

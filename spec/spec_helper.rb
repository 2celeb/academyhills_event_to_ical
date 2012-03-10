require File.join(File.dirname(__FILE__), '..', 'calendar.rb')
require File.join(File.dirname(__FILE__), '..', 'event.rb')

require 'rubygems'
require 'sinatra'
require 'icalendar'
require 'nokogiri'
require 'open-uri'
require 'active_support'
require 'rack/test'

=begin
require 'rspec'
require 'rspec/autorun'
require 'rspec/interop/test'
=end
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false


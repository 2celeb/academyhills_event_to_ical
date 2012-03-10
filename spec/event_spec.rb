require File.dirname(__FILE__) + '/spec_helper'


describe "Event" do
  include Rack::Test::Methods


  before :each do
    @event = Event.new(Date.today.year,Date.today.month)
  end

  it "get url" do
    @event.crawl_urls.empty?.should be_false
  end

  it "get events" do
    @event.events.size.should > 0
  end

  it "to_ical" do
    puts @event.events.to_ical
  end






end


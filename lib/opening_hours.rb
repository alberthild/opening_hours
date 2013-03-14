require 'time'
require 'date'
require 'active_support/time'
require "opening_hours/version"

class OpeningHours

  class OpenHours

    attr_reader :open, :close

    def initialize(open, close)
      @open, @close = open, close
    end

    def duration
      @duration ||= @open < @close ? @close - @open : 0
    end

    CLOSED = new(0, 0)

    def self.parse(open, close)
      open  = Time.parse(open)
      close = Time.parse(close)
    
      open  = TimeUtils::seconds_from_midnight(open)
      close = TimeUtils::seconds_from_midnight(close)
    
      new(open, close)
    end

    def offset(seconds)
      self.class.new([@open, seconds].max, @close)
    end

  end

  module TimeUtils

    class << self

      def seconds_from_midnight(time)
        time.hour*60*60 + time.min*60 + time.sec
      end
      
      def time_from_midnight(seconds)
        hours, seconds = seconds.divmod(60 * 60)
        minutes, seconds = seconds.divmod(60)
        [hours, minutes, seconds]
      end

    end

  end

  # makes it possible to access each day like: b.week[:sun].open, or iterate through all weekdays
  attr_reader :week

  WEEK_DAYS = Time::RFC2822_DAY_NAME.map { |m| m.downcase.to_sym }

  def initialize(start_time, end_time, time_zone = Time.now.gmt_offset)
    open_hours = OpenHours.parse(start_time, end_time)

    @time_zone = time_zone

    @week = {}
    WEEK_DAYS.each do |day|
      @week[day] = open_hours
    end

    @specific_days = {}
  end

  def update(day, start_time, end_time, time_zone = Time.now.zone)

    @time_zone = time_zone

    set_open_hours day, OpenHours.parse(start_time, end_time)
  end

  def closed(*days)
    days.each do |day|
      set_open_hours day, OpenHours::CLOSED
    end
  end

  def now_open?
    calculate_deadline(0, Time.now.to_s) == Time.now.to_formatted_s(:rfc822)
  end

  def calculate_deadline(job_duration, start_date_time)
    Time.zone = @time_zone
    start_date_time = Time.zone.parse(start_date_time)

    today = Date.civil(start_date_time.year, start_date_time.month, start_date_time.day)
    open_hours = get_open_hours(today).offset(TimeUtils::seconds_from_midnight(start_date_time))

    # here is possible to use strict greater operator if you want to stop on edge of previous business day.
    # see "BusinessHours schedule without exceptions should flip the edge" spec
    while job_duration >= open_hours.duration
      job_duration -= open_hours.duration

      today = today.next
      open_hours = get_open_hours(today)
    end

    Time.zone.local(today.year, today.month, today.day, *TimeUtils::time_from_midnight(open_hours.open + job_duration)).to_formatted_s(:rfc822)
  end

  private

  def get_open_hours(date)
    @specific_days[date] || @week[WEEK_DAYS[date.wday]]
  end

  def set_open_hours(day, open_hours)
    case day
    when Symbol
      @week[day] = open_hours
    when String
      @specific_days[Date.parse(day)] = open_hours
    end
  end

end

class Time
  class << self
    def parse_rfc822(date, now=self.now)
      parse(date, now).to_formatted_s(:rfc822)
    end
  end
end
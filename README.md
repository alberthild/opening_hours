# OpeningHours

Let you apply opening hours, closed periods and holidays to all kind of business including timezone support. Heavily based on the code from pleax (RPCFN#10: Business Hours competition winner) - thx a lot: [Source](https://gist.github.com/pleax/e9c0da1a6e92dd12cbc7)

## Installation

Add this line to your application's Gemfile:

    gem 'opening_hours'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opening_hours

## Usage

Init new hours object:
```ruby
hours = OpeningHours.new("9:00 AM", "3:00 PM", "Europe/Berlin")
```

Methods to set the hours, closed times or holidays:
```ruby
hours.update :fri, "10:00 AM", "5:00 PM"
hours.break :fri, "01:00 PM", "1:30 PM"
hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"
hours.closed :sun, :wed, "Dec 25, 2010"
```

Calculate the deadline (next available working hour)
```ruby
# offset and time
hours.calculate_deadline(4*60*60, "Dec 23, 2010 8:00 PM")
  => "Fri, 24 Dec 2010 13:00:00 +0100" 

# now with timezone
hours.calculate_deadline(0, "Dec 23, 2010 9:00 AM -0400")
  => "Thu, 23 Dec 2010 14:00:00 +0100" 
```

Check if business is open right now:
```ruby
hours.now_open?
```

And get all week days with values:
```ruby
hours.week.each do |day|
  puts day[1].open
end
```

Get human readable opening/close hours
```ruby
hours.week[:mon].open.to_human_readable_hours
 => "09:00 AM" 

hours.week[:mon].close.to_human_readable_hours
 => "03:00 PM" 
```

You can fetch breaks also. Sorry for confusion... but i used same OpeningHour class for breaks as for the original hours.. thats why the attributes here are open and close too. But actually .open and .close means when break starts and ends.
```ruby
hours.breaks[:fri].open.to_human_readable_hours
 => "01:00 AM" 

hours.breaks[:fri].close.to_human_readable_hours
 => "01:30 PM" 
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

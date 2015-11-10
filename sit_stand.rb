require 'timers'
require 'daemons'

class Fixnum
  def seconds
    self
  end

  def minutes
    self * 60
  end

  def hours
    self * 60 * 60
  end
end

class SitStand
  def initialize
    @timers = Timers::Group.new
    @every_five_seconds = @timers.every(20.minutes) { notify }
    @position = "sit"
    notify
  end

  def sit_or_stand
    @position = @position == "sit" ? "stand" : "sit"
  end

  def notify
    %x{terminal-notifier -message "Time to #{sit_or_stand}!"}
  end

  def run
    loop { @timers.wait }
  end
end

Daemons.run_proc('SitStand') do
  app = SitStand.new
  app.run
end


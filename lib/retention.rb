class Retention
  attr_reader :name, :time, :code
  
  def initialize(name, time, code)
    @name = name
    @time = time
    @code = code
  end
  
  def self.from_i(int)
    return case int
      when 1 then return HOUR
      when 2 then return DAY
      when 3 then return WEEK
      when 4 then return MONTH
      when 5 then return FOREVER
      else return HOUR
    end
  end
  
  HOUR = Retention.new("Hour", 1.hour, "h").freeze
  DAY = Retention.new("Day", 1.day, "d").freeze
  WEEK = Retention.new("Week", 1.week, "w").freeze
  MONTH = Retention.new("Month", 1.month, "m").freeze
  FOREVER = Retention.new("Forever", 255.years, "f").freeze
  
  ALL = [HOUR, DAY, WEEK, MONTH, FOREVER].freeze
end
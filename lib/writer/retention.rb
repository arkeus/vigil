class Retention
  attr_reader :name, :time, :code
  
  def initialize(name, time, code)
    @name = name
    @time = time
    @code = code
  end
  
  def self.from_i(int)
    return case int
      when 0 then return HOUR
      when 1 then return DAY
      when 2 then return WEEK
      when 3 then return MONTH
      else return HOUR
    end
  end
  
  HOUR = initialize("Hour", 1.hour, "h").freeze
  DAY = initialize("Day", 1.day, "d").freeze
  WEEK = initialize("Week", 1.week, "w").freeze
  MONTH = initialize("Month", 1.month, "m").freeze
  
  ALL = [HOUR, DAY, WEEK, MONTH].freeze
end
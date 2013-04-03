module PasteHelper
  def duration(start_time, end_time)
    seconds = end_time - start_time
    hours = (seconds / 3600).floor
    return "Never" if hours > 100000
    return "#{hours} hours" if hours > 0
    minutes = (seconds / 60).floor
    return "#{minutes} minutes" if minutes > 0
    return "#{seconds.floor} seconds"
  end
  
  def file_container_width(width)
    width += 10
    return width < 200 ? 200 : width > 810 ? 810 : width
  end
end

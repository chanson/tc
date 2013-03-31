module TaskHelper
  def deadlineString(deadline)
    case deadline
    when :expired
      "Expired"
    when :today
      "Today"
    when :tomorrow
      "Tomorrow"
    when :week
      "Upcoming Week"
    when :month
      "Upcoming Month"
    when :future
      "Over One Month"
    when :any
      "All Tasks"
    else
      raise IndexError, "unknown task deadline '#{deadline}'"
    end
  end
end
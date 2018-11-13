module ApplicationHelper
  def direction_button_style(direction)
    @direction == direction ? 'btn btn-secondary' : 'btn btn-outline-secondary'
  end
end

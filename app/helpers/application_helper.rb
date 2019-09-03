# frozen_string_literal: true

module ApplicationHelper
  def direction_button_style(direction)
    @direction == direction ? 'link-active' : 'link-inactive'
  end
end

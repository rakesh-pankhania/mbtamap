# frozen_string_literal: true

module ApplicationHelper
  def direction_button_style(direction)
    @direction == direction ? 'text-center is-active' : 'text-center'
  end
end

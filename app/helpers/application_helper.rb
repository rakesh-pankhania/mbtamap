# frozen_string_literal: true

module ApplicationHelper
  def direction_button_style(direction)
    @direction == direction ? 'tabs-title text-center is-active' : 'tabs-title text-center'
  end
end

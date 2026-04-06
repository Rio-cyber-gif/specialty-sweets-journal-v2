# frozen_string_literal: true

module ApplicationHelper
  def flash_class(key)
    case key.to_s
    when 'success', 'notice'
      'bg-green-100 border border-green-400 text-green-700'
    when 'danger', 'alert'
      'bg-red-100 border border-red-400 text-red-700'
    else
      'bg-gray-100 border border-gray-400 text-gray-700'
    end
  end
end

module ApplicationHelper
    def flash_class(type)
      case type
      when 'notice'
        'alert-success'
      when 'alert', 'error'
        'alert-danger'
      else
        'alert-info'
      end
    end
  end
module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title)
  	welcome_title = "Welcome to #{NAME}!"
    base_title    = NAME
    if page_title.empty?
      welcome_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def body_bg(no_bg)
    return "no-bg" if no_bg == "no-bg"
  end
end

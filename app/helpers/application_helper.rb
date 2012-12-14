module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title)
  	welcome_title = "Welcome to Dragon!"
    base_title    = "Dragon"
    if page_title.empty?
      welcome_title
    else
      "#{base_title} | #{page_title}"
    end
  end


end

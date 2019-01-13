module ApplicationHelper

  # возвращает полный загололвок для каждой страницы
  def full_title(page_title)
    base_title = "Steh"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

end

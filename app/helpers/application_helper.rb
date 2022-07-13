module ApplicationHelper
    def full_title(page_title = '')
        base_url = 'Ruby on Rails Tutorial Sample App'
        if page_title.empty?
            base_url
        else
            page_title + ' | ' + base_url
        end
    end
end

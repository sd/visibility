module Visibility
  def self.capture_original_process_name
    @original_process_name_before_visibility = $0
  end
  
  def self.original_process_name
    @original_process_name_before_visibility
  end
  
  def self.title_prefix
    original_process_name
  end

  def self.set_title(title, options = {})
    if options[:append_to_current] && @current_title_for_visibility
      new_title = "#{@current_title_for_visibility}: #{title}"
    elsif options[:no_prefix]
      new_title = "#{title}"
    else
      new_title = "#{Visibility.title_prefix}: #{title}"
    end
    
    if options[:timestamp]
      new_title += " [#{Time.now.strftime("%H:%M:%S")}]"
    end
    
    @current_title_for_visibility = new_title
    $0 = new_title
  end
  
  def self.push_title(title, options = {})
    @saved_titles_for_visibility ||= []
    @saved_titles_for_visibility.push($0)
    Visibility.set_title(title, options)
  end
  
  def self.pop_title
    @saved_titles_for_visibility ||= []
    Visibility.set_title(@saved_titles_for_visibility.pop, :no_prefix => true)
    if @saved_titles_for_visibility.size == 0
      @current_title_for_visibility = nil
    end
  end
end

Visibility.capture_original_process_name

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
end

Visibility.capture_original_process_name
module Visibility
  module RailsRequest
    def self.included(includer)
      includer.send(:alias_method_chain, :process, :visibility)
    end

    def title_for_request(request)
      if request
        name = "#{request.request_method.to_s.upcase} #{request.request_uri}"
      else
        "?"
      end
    rescue
      "!"
    end
  
    def process_with_visibility(request, response, method = :perform_action, *arguments)
      saved_process_name = $0
      if $0 == Visibility.original_process_name
        $0 = "#{Visibility.title_prefix}: #{title_for_request(request)}"
      else
        $0 = "#{saved_process_name}: #{title_for_request(request)}"
      end
      
      result = process_without_visibility(request, response, method, *arguments)

      $0 = saved_process_name

      result
    end
  end
end

ActionController::Base.send(:include, Visibility::RailsRequest)

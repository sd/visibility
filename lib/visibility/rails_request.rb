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
      Visibility.push_title(title_for_request(request), :append_to_current => true)
      result = process_without_visibility(request, response, method, *arguments)
      Visibility.pop_title
      result
    end
  end
end

ActionController::Base.send(:include, Visibility::RailsRequest)

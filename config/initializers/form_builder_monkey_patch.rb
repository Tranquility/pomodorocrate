module ActionView
  module Helpers
    class FormBuilder
      # code from rails 3.0
      def submit(value=nil, options={})
        value, options = nil, value if value.is_a?(Hash)
        value ||= submit_default_value
        @template.submit_tag(value, options.reverse_merge(:id => "#{object_name}_submit"))
      end
    end
  end
end
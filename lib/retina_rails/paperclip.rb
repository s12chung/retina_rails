module RetinaRails

  module Paperclip

    extend ActiveSupport::Concern

    included do

      ## Override paperclip default options
      RetinaRails::Extensions.override_default_options

      ## Iterate over each has_attached_file
      attachment_definitions.each_pair do |key, value|

        ## Check for style definitions
        styles = attachment_definitions[key][:styles]

        if styles

          retina_styles = {}

          ## Iterate over styles and set optimzed dimensions
          styles.each_pair do |key, value|

            dimensions = value[0]

            width  = dimensions.scan(/\d+/)[0].to_i * 2
            height = dimensions.scan(/\d+/)[1].to_i * 2

            processor = dimensions.scan(/#|</).first

            retina_styles["#{key}_retina".to_sym] = ["#{width}x#{height}#{processor}", value[1]]

          end

          ## Append new retina optimzed styles
          value[:styles].merge!(retina_styles)

          ## Make path work with retina optimization
          original_path = attachment_definitions[key][:path]
          value[:path] = RetinaRails::Extensions.optimize_path(original_path) if original_path

          ## Make url work with retina optimization
          original_url = attachment_definitions[key][:url]
          value[:url] = RetinaRails::Extensions.optimize_path(original_url) if original_url

        end

      end

    end

  end

end
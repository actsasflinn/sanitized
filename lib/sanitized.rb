module ActiveRecord
  module Sanitized
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def sanitized(*args)
        before_validation :sanitize_attributes

        sanitized_attributes = {}
        options = args.extract_options!
        args.each do |attribute|
          sanitized_attributes[attribute] = options
        end
        write_inheritable_attribute(:sanitized_attributes, sanitized_attributes)
        class_inheritable_reader :sanitized_attributes
      end
    end

    def sanitize_attributes
      self.class.sanitized_attributes.each_pair do |attr, options|
        if unsanitized = self.send(attr)
          self.send("#{attr}=", Sanitize.clean(unsanitized, options))
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Sanitized)

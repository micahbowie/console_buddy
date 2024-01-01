# frozen_string_literal: true


# Example:
# 
# Here we are defining a method called `sps` on the `User` model.
# This method will return the saved posts for a given user record.
# 
# 
# ConsoleBuddy::Augment.define do
#   method User, :sps do |args|
#     saved_posts
#   end
# end

module ConsoleBuddy
  class Augment
    class << self
      def define(&block)
        if block_given?
          instance = ::ConsoleBuddy::Augment::DSL.new
          instance.instance_eval(&block)
        end
      end
    end

    class DSL
      def method(klass, method_name, &block)
        ConsoleBuddy.store.augment_helper_methods[klass.to_s] <<  { method_name: method_name, block: block, method_type: :instance }
      end

      def method_alias(klass, method_name, new_method_name)
        block = ::Proc.new { |*args| send(method_name, *args) }
        ConsoleBuddy.store.augment_helper_methods[klass.to_s] <<  { method_name: new_method_name, block: block, method_type: :instance  }
      end

      def class_method_alias(klass, method_name, new_method_name)
        block = ::Proc.new { |*args| send(method_name, *args) }
        ConsoleBuddy.store.augment_helper_methods[klass.to_s] <<  { method_name: new_method_name, block: block, method_type: :class  }
      end

      def class_method(klass, method_name, &block)
        ConsoleBuddy.store.augment_helper_methods[klass.to_s] <<  { method_name: method_name, block: block, method_type: :class }
      end
    end
  end
end

# frozen_string_literal: true


# Example:
# 
# Here we are defining a method called `sps` on the `User` model.
# This method will return the saved posts for a given user record.
# 
# 
# ConsoleBuddy::ActiveRecordHelpers.define do
#   model_method User, :sps do |args|
#     saved_posts
#   end
# end

module ConsoleBuddy
  class ActiveRecordHelpers
    class << self
      def define(&block)
        if block_given?
          instance = ::ConsoleBuddy::ActiveRecordHelpers::DSL.new
          instance.instance_eval(&block)
        end
      end
    end

    class DSL
      def model_method(klass, method_name, &block)
        ConsoleBuddy.store.active_record_helper_methods[klass.to_s] <<  { method_name: method_name, block: block }
        # klass.define_method(method_name) do |*args|
        #   instance_exec(*args, &block)
        # end
      end
    end
  end
end

module Mongoid
  module Chronology
    def self.included(base)
      base.send(:extend,  ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def has_chronology(*args)
        field :current_year, type: Integer, default: 0
        cattr_accessor :currrent_year
      end
    end

    module InstanceMethods
      def new_year
        self.current_year += 1
      end
    end
  end
end



module Phitris
  module Config
    def self.included(klass)
      klass.extend ClassMethods
      
      if klass.is_a? Class
        klass.class_eval <<-RUBY
          def config(hash = nil)
            self.class.config(hash)
          end
        RUBY
      end
    end
    
    module ClassMethods
      def config(hash = nil)
        if hash
          self.config = hash
        else
          (defined?(superclass.config) ? superclass.config : {}).merge(@config ||= {})
        end
      end

      def config=(hash)
        rest = {}
        hash.each do |key,value|
          if (constant = const_get(key) rescue Phitris.const_get(key) rescue nil)
            constant.config = value
          else
            rest[key.to_sym] = value
          end
        end
        (@config ||= {}).update(rest)
      end
    end
  end
end

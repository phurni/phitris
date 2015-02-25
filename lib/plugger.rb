module Phitris
  module Plugger
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    module ClassMethods
      def plug(*modules)
        options = modules.last.is_a?(Hash) ? modules.pop : {}
        modules.each do |module_name|
          module_name = module_name.to_s
          module_camelized = module_name.gsub(/(^\w|_\w)/) {|item| item.sub('_', '').upcase}

          module_eval <<-RUBY
            module #{module_camelized}
              include *#{Array(options[:modules]).inspect}
              def self.all
                constants.map {|c| const_get c}
              end
            end
          RUBY

          # load all modules
          Dir[File.join(options[:basedir] || '.', module_name, '*.rb')].each {|file| require file }
        end
      end
    end
  end
end

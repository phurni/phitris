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
          module_camelized = module_name.split("_").map(&:capitalize).join

          new_module = Module.new do
            def self.all
              constants.map {|c| const_get c}
            end
          end
          new_module.include(*Array(options[:modules]))
          Phitris.const_set(module_camelized, new_module)

          # load all modules
          require_dir(File.join(options[:basedir] || '.', module_name))
        end
      end
    end
  end
end

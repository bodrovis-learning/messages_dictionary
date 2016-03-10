module PrettyOutputter
  def self.included(klass)
    klass.class_exec do
      define_method :initialize do
        begin
          file_contents = YAML.load_file("#{klass.name}.yml").symbolize_keys
        rescue Errno::ENOENT
          abort "File #{klass.name + '.yml'} does not exist..."
        else
          klass.const_set(:MESSAGES, file_contents)
        end
      end

      define_method :render do |key, values = {}|
        return unless klass::MESSAGES.has_key?(key)

        msg = klass::MESSAGES[key]
        values.each do |k, v|
          msg.gsub!(Regexp.new('\{\{' + k.to_s + '\}\}'), v.to_s)
        end
        puts msg
      end

      private :render
    end
  end
end
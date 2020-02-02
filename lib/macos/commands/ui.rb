require 'macos'

module Macos
  module Commands
    class Ui < Macos::Command
      def call(_args, _name)
        action = nil

        CLI::UI::Frame.open('macOS Bootstraper', color: :green) do
          puts CLI::UI.fmt I18n.t(:test)
        end

        # action = CLI::UI::Prompt.ask('What language/framework do you use?') do |handler|
        #   handler.option('rails')  { |selection| selection }
        #   handler.option('go')     { |selection| selection }
        #   handler.option('ruby')   { |selection| selection }
        #   handler.option('python') { |selection| selection }
        # end

        # puts CLI::UI.fmt '{{red:please input your password for `sudo`.}}'

      end

      def self.help; end

      private

      def macos_version
        @macos_version ||= `/usr/bin/sw_vers -productVersion`
      end
    end
  end
end

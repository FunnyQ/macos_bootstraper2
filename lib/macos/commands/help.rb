require 'macos'

module Macos
  module Commands
    class Help < Macos::Command
      def call(args, _name)
        divider = CLI::UI.fmt('=' * 50)

        # header
        puts divider
        puts CLI::UI.fmt(I18n.t(:available_commands))
        puts divider + %(\n\n)

        # commend list
        Macos::Commands::Registry.resolved_commands.each do |name, klass|
          next if name == 'help'

          locale_key = %(commands.#{klass.name.split('::').last.downcase})

          puts CLI::UI.fmt(%({{yellow:- #{I18n.t("#{locale_key}.help")}}}))
          puts CLI::UI.fmt(%(  {{command:#{Macos::TOOL_NAME} #{I18n.t("#{locale_key}.command")}}}))
          I18n.t(%(#{locale_key}.args)).each do |arg|
            puts %(    #{arg})
          end
          puts ''
        end
      end
    end
  end
end

require 'macos'

module Macos
  module Commands
    class Locale < Macos::Command
      include Macos::LocaleConfig

      def call(_args, _name)
        locale_files = Dir[File.expand_path('./lib/macos/locales/*.yml')]
        available_locales = locale_files.map { |path| File.basename(path, '.yml') }

        prefer_locale = CLI::UI::Prompt.ask(I18n.t(:locale_menu_message)) do |handler|
          available_locales.each do |locale|
            handler.option(I18n.t("available_locales.#{locale}")) { |_selection| locale }
          end

          handler.option(I18n.t("actions.cancel")) { |selection| :cancel }
        end

        set_locale_to(prefer_locale) unless prefer_locale == :cancel
      end

      def self.help; end
    end
  end
end

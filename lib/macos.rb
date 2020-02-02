require 'cli/ui'
require 'cli/kit'
require 'i18n'
require 'byebug'


CLI::UI::StdoutRouter.enable

module Macos
  extend CLI::Kit::Autocall

  TOOL_NAME = 'macos'.freeze
  ROOT      = File.expand_path('../..', __FILE__)
  LOG_FILE  = '/tmp/macos.log'.freeze
  DEFAULT_LOCALE = :zh_TW
  LOCALE_PREFERENCES_PATH = './preferences/locale.txt'.freeze

  autoload(:LocaleConfig, 'macos/locale_config')
  autoload(:EntryPoint,   'macos/entry_point')
  autoload(:Commands,     'macos/commands')

  autocall(:Config)  { CLI::Kit::Config.new(tool_name: TOOL_NAME) }
  autocall(:Command) { CLI::Kit::BaseCommand }

  autocall(:Executor) { CLI::Kit::Executor.new(log_file: LOG_FILE) }
  autocall(:Resolver) do
    CLI::Kit::Resolver.new(
      tool_name: TOOL_NAME,
      command_registry: Macos::Commands::Registry
    )
  end

  autocall(:ErrorHandler) do
    CLI::Kit::ErrorHandler.new(
      log_file: LOG_FILE,
      exception_reporter: nil
    )
  end

  # init i18n
  I18n.load_path << Dir[File.expand_path('./lib/macos/locales/*.yml')]
  I18n.default_locale = DEFAULT_LOCALE
  I18n.locale = Macos::LocaleConfig.current_locale.to_sym
end

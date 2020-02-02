require 'macos'

module Macos
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(
      default: 'ui',
      contextual_resolver: nil
    )

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(->() { const_get(const) }, cmd)
    end

    register :Ui, 'ui', 'macos/commands/ui'
    register :Locale, 'locale', 'macos/commands/locale'
    register :Help, 'help', 'macos/commands/help'
  end
end

require 'macos'

module Macos
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = Macos::Resolver.call(args)
      Macos::Executor.call(cmd, command_name, args)
    end
  end
end

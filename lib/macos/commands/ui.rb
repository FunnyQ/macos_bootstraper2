require 'macos'

module Macos
  module Commands
    class Ui < Macos::Command
      def call(_args, _name)
        action = nil

        clear_screen

        CLI::UI::Frame.open('macOS Bootstraper', color: :green) do
          puts CLI::UI.fmt I18n.t(:current_macos_version_is_x, x: macos_version)
        end

        action = CLI::UI::Prompt.ask(I18n.t()) do |handler|
          handler.option(I18n.t('commands.ui.backup_ssh_and_gpg_keys'))  { |selection| :backup_ssh_and_gpg_keys }
          handler.option(I18n.t('commands.ui.setup_macos_preferences'))  { |selection| :setup_macos_preferences }
          handler.option(I18n.t('actions.cancel')) { |selection| :cancel }
        end

        # puts CLI::UI.fmt '{{red:please input your password for `sudo`.}}'
        return exit_script if action == :cancel

        send(action)
      end

      def self.help; end

      private

      def clear_screen
        system 'clear'
      end

      def macos_version
        @macos_version ||= `/usr/bin/sw_vers -productVersion`
      end

      def backup_ssh_and_gpg_keys
        clear_screen

        CLI::UI::Frame.open('Backup SSH and GPG keys', color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.backup_ssh_and_gpg_keys_message')
        end

        target_path = CLI::UI::Prompt.ask('where to store backup?', default: '~/macos_backups/dotfiles')

        CLI::UI::Spinner.spin('coping files...') do |spinner|
          system "mkdir -p #{target_path}"
          system "cp -r ~/.ssh #{target_path}/ssh"
          system "cp -r ~/.gnupg #{target_path}/gnupg"
        end

        puts ''
        puts CLI::UI.fmt %({{green:#{I18n.t(:done)}}})
      end

      def setup_macos_preferences
        clear_screen

        CLI::UI::Frame.open(I18n.t('commands.ui.setup_macos_preferences'), color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.setup_macos_preferences_message')
        end

        system 'sudo -v'

        Macos::SystemPreferences.docker
        Macos::SystemPreferences.finder
        Macos::SystemPreferences.keyboard
        Macos::SystemPreferences.trackpad
        Macos::SystemPreferences.system_config
        Macos::SystemPreferences.restart_apps

        puts ''
        puts CLI::UI.fmt %({{green:#{I18n.t(:done_and_need_reboot)}}})
      end

      def exit_script
        puts CLI::UI.fmt %({{red:#{I18n.t('commands.ui.canceled')}}})
      end
    end
  end
end

require 'macos'

module Macos
  module Commands
    class Ui < Macos::Command
      def call(_args, _name)
        action = nil

        clear_screen


        CLI::UI::Frame.open('macOS Bootstraper', color: :green)
        puts CLI::UI.fmt I18n.t(:current_macos_version_is_x, x: macos_version)
        CLI::UI::Frame.close(" #{`pwd`}", color: :green)

        action = CLI::UI::Prompt.ask(I18n.t()) do |handler|
          handler.option(I18n.t('commands.ui.backup_ssh_and_gpg_keys'))  { |selection| :backup_ssh_and_gpg_keys }
          handler.option(I18n.t('commands.ui.system_basic_setup'))  { |selection| :system_basic_setup }
          handler.option(I18n.t('commands.ui.setup_dev_env'))  { |selection| :setup_dev_env }
          handler.option(I18n.t('commands.ui.setup_macos_preferences'))  { |selection| :setup_macos_preferences }
          handler.option(I18n.t('commands.ui.create_ramdisk'))  { |selection| :create_ramdisk }
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

        CLI::UI::Frame.open(I18n.t('commands.ui.backup_ssh_and_gpg_keys'), color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.backup_ssh_and_gpg_keys_message')
        end

        target_path = CLI::UI::Prompt.ask(I18n.t('commands.ui.backup_path'), default: '~/macos_backups/dotfiles')

        CLI::UI::Spinner.spin('coping files...') do |spinner|
          system "mkdir -p #{target_path}"
          system "cp -r ~/.ssh #{target_path}/ssh"
          system "cp -r ~/.gnupg #{target_path}/gnupg"
        end

        puts ''
        puts CLI::UI.fmt %({{green:#{I18n.t(:done)}}})
      end

      def system_basic_setup
        clear_screen

        CLI::UI::Frame.open(I18n.t('commands.ui.system_basic_setup'), color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.system_basic_setup_message')
        end

        script = File.open("#{SCRIPTS_PATH}/basic_setup.sh")

        system "zsh #{script.path}"
      end

      def setup_dev_env
        clear_screen

        CLI::UI::Frame.open(I18n.t('commands.ui.setup_dev_env'), color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.setup_dev_env_message')
        end

        script = File.open("#{SCRIPTS_PATH}/setup_dev_env.sh")
        brewfile = File.open("#{SCRIPTS_PATH}/Brewfile")

        system "zsh #{script.path} #{brewfile.path}"
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

      def create_ramdisk
        clear_screen

        CLI::UI::Frame.open(I18n.t('commands.ui.create_ramdisk'), color: :green) do
          puts CLI::UI.fmt I18n.t('commands.ui.create_ramdisk_message')
        end

        disk_name = CLI::UI::Prompt.ask(I18n.t('commands.ui.disk_name'), default: 'RamDisk')
        disk_size = CLI::UI::Prompt.ask(I18n.t('commands.ui.disk_size'), default: '1')

        CLI::UI::Spinner.spin("Creating #{disk_name}...") do |spinner|
          system %(diskutil erasevolume HFS+ "#{disk_name}" `hdiutil attach -nomount ram://$((#{disk_size}*2097152))` > /dev/null)
        end
      end

      def exit_script
        puts CLI::UI.fmt %({{red:#{I18n.t('commands.ui.canceled')}}})
      end
    end
  end
end

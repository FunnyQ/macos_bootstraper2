module Macos
  module LocaleConfig
    def current_locale
      Macos::LocaleConfig.current_locale
    end

    def set_locale_to(new_locale)
      Macos::LocaleConfig.set_locale_to(new_locale)
    end

    def self.current_locale
      if File.exists?(LOCALE_PREFERENCES_PATH)
        preferences_file = File.open(LOCALE_PREFERENCES_PATH)

        preferences_file.readline
      else
        system "mkdir -p #{File.dirname(LOCALE_PREFERENCES_PATH)}"
        preferences_file = File.open(LOCALE_PREFERENCES_PATH, 'w')

        preferences_file.write(DEFAULT_LOCALE)
        preferences_file.close

        DEFAULT_LOCALE.to_s
      end
    end

    def self.set_locale_to(new_locale)
      preferences_file = File.open(LOCALE_PREFERENCES_PATH, 'w')

      preferences_file.write(new_locale)
      preferences_file.close
    end
  end
end

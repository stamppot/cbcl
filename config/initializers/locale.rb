# tell the I18n library where to find your translations
I18n.load_path += Dir[ File.join(RAILS_ROOT, 'lib', 'locale', '*.{rb,yml}') ]

# you can omit this if you're happy with English as a default locale
I18n.default_locale = "da-DK"
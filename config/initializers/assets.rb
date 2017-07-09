# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application_all.js, application.css.sass, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Soportar la nueva estructura de las assets
Rails.application.config.assets.precompile +=
    %w( application_custom.css.sass application_main_page.css.sass application_carrier_dashboard.css.sass )
Rails.application.config.assets.precompile +=
    %w( application_custom.js application_main_page.js application_carrier_dashboard.js )

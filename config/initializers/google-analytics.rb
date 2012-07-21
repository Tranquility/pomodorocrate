## To enable google analytics, fill GA_ACCOUNT and GA_DOMAIN in .env if possible or modify the lines below

Ketchup::Application.config.ga_account = ENV['GA_ACCOUNT'] # || 'YourGoogleAnalyticsId'
Ketchup::Application.config.ga_domain = ENV['GA_DOMAIN']   # || 'YourDomainHere'
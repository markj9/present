require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Present
  class Application < Rails::Application
    config.present = ActiveSupport::OrderedOptions.new
    config.present.admins = Rails.application.secrets.admin_github_ids
    config.present.local_override = ENV['LOCAL_OVERRIDE_AS'] || false
    config.present.company_name = ENV['PRESENT_COMPANY_NAME'] || "Test Double"

    config.github = ActiveSupport::OrderedOptions.new
    config.github.client_id = Rails.application.secrets.github_client_id
    config.github.organization_name = ENV['PRESENT_GITHUB_ORGANIZATION_NAME']

    config.harvest = ActiveSupport::OrderedOptions.new
    config.harvest.subdomain = Rails.application.secrets.harvest_subdomain
    config.harvest.username = Rails.application.secrets.harvest_username

    config.autoload_paths = ["#{Rails.root}/lib"]
  end
end

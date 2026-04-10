# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes
  register_value_helper :form_authenticity_token
  register_value_helper :current_user
  register_value_helper :current_account
  register_value_helper :current_event
  register_value_helper :request

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end

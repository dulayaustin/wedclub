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
  register_value_helper :flash

  def render_flash
    if flash[:notice].present?
      Alert(variant: :success, class: "mb-6") do
        AlertDescription { flash[:notice] }
      end
    end
    if flash[:alert].present?
      Alert(variant: :destructive, class: "mb-6") do
        AlertDescription { flash[:alert] }
      end
    end
  end

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end

# frozen_string_literal: true

module Heya
  module Campaigns
    module Actions
      class Email < Action
        VALID_PARAMS = %w[subject from reply_to bcc layout to headers before after]

        def self.validate_step(step)
          step.params.assert_valid_keys(VALID_PARAMS)
          unless step.params["subject"].present? || I18n.exists?("#{step.campaign_name.underscore}.#{step.name.underscore}.subject")
            raise ArgumentError.new(%("subject" is required))
          end
          ["before", "after"].each do |callback|
            raise ArgumentError.new("#{callback} must be callable") if step.params[callback] && !step.params[callback].respond_to?(:call)
          end
        end

        def build
          CampaignMailer
            .with(user: user, step: step)
            .build
        end
      end
    end
  end
end

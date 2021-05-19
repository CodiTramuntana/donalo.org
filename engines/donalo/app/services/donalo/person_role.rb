module Donalo
  class PersonRole
    attr_reader :person

    CUSTOM_FIELD_NAME = '_Rol'.freeze
    PRO_CUSTOM_FIELD_TITLE = 'Pro'.freeze

    def initialize(person)
      @person = person
    end

    def pro?
      return false unless person
      return false unless pro_option_id

      custom_field_value_options.include? pro_option_id
    end

    private

    def custom_field_value_options
      return [] unless custom_field_value

      custom_field_value.selected_options.pluck(:id)
    end

    def custom_field_value
      return unless custom_field_id

      @custom_field_value ||= person.custom_field_values.find_by(custom_field_id: custom_field_id)
    end

    def custom_field_id
      custom_field_name&.custom_field_id
    end

    def custom_field
      return unless custom_field_id

      @custom_field ||= CustomField.find_by id: custom_field_id
    end

    def custom_field_name
      @custom_field_name ||= CustomFieldName.find_by(value: CUSTOM_FIELD_NAME)
    end

    def pro_option_id
      return nil unless custom_field

      @pro_option_id ||= custom_field.options.detect { |o| o.title == PRO_CUSTOM_FIELD_TITLE }&.id
    end
  end
end


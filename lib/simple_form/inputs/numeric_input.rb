module SimpleForm
  module Inputs
    class NumericInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        input_options[:type]        ||= "number"
        input_options[:size]        ||= SimpleForm.default_input_size
        input_options[:step]        ||= 1 if integer?
        input_options[:placeholder] ||= placeholder if has_placeholder?
        infer_attributes_from_validations(input_options)
        input_options
      end

      def input_html_classes
        super.unshift("numeric")
      end

    protected

      def infer_attributes_from_validations(input_options)
        return unless has_validators?

        numeric_validator = find_numericality_validator or return
        validator_options = numeric_validator.options

        input_options[:min] ||= minimum_value(validator_options)
        input_options[:max] ||= maximum_value(validator_options)
      end

      def integer?
        input_type == :integer
      end

      def minimum_value(validator_options)
        if integer? && validator_options.key?(:greater_than)
          validator_options[:greater_than] + 1
        else
          validator_options[:greater_than_or_equal_to]
        end
      end

      def maximum_value(validator_options)
        if integer? && validator_options.key?(:less_than)
          validator_options[:less_than] - 1
        else
          validator_options[:less_than_or_equal_to]
        end
      end

      def find_numericality_validator
        attribute_validators.find { |v| ActiveModel::Validations::NumericalityValidator === v }
      end
    end
  end
end

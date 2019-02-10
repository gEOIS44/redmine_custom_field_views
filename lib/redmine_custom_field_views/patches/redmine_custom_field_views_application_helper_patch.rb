require_dependency 'application_helper'

module RedmineCustomFieldViews
  module ApplicationHelperPatch
    def allocation_columns(custom_field_values)
      columns_by_types = []
      columns_by_type = Hash.new
      line_of_one_items = []
      line_of_two_items = []
      custom_field_values.each do |value|
        if value.custom_field.format_store[:full_width_layout] == "1"
          if line_of_two_items.present?
            columns_by_type = Hash.new
            columns_by_type["2"] = line_of_two_items
            columns_by_types << columns_by_type
            line_of_two_items = []
          end
          line_of_one_items << value
        elsif value.custom_field.format_store[:full_width_layout].blank? && value.custom_field.field_format == "text"
          if line_of_two_items.present?
            columns_by_type = Hash.new
            columns_by_type["2"] = line_of_two_items
            columns_by_types << columns_by_type
            line_of_two_items = []
          end
          line_of_one_items << value
        else
          if line_of_one_items.present?
            columns_by_type = Hash.new
            columns_by_type["1"] = line_of_one_items
            columns_by_types << columns_by_type
            line_of_one_items = []
          end
          line_of_two_items << value
        end
      end
      if line_of_one_items.present?
        columns_by_type = Hash.new
        columns_by_type["1"] = line_of_one_items
        columns_by_types << columns_by_type
      end
      if line_of_two_items.present?
        columns_by_type = Hash.new
        columns_by_type["2"] = line_of_two_items
        columns_by_types << columns_by_type
      end
      columns_by_types
    end
  end
end

ApplicationHelper.prepend(RedmineCustomFieldViews::ApplicationHelperPatch)

require_dependency 'issues_helper'

module RedmineCustomFieldViews
  module Patches
    module RedmineCustomFieldViewsIssuesHelperPatch
      def self.included(base)
        base.send(:include, RedmineCustomFieldViewsInstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :render_custom_fields_rows, :redmine_custom_field_views
        end
      end

      module RedmineCustomFieldViewsInstanceMethods
        def render_custom_fields_rows_with_redmine_custom_field_views(issue)
          s = ""
          columns_by_types = allocation_columns(issue.custom_field_values)
          columns_by_types.each do |columns_by_type|
            columns_by_type.each do |key, values|
              if key == "2"
                half = (values.size / 2.0).ceil
                s << issue_fields_rows do |rows|
                  values.each_with_index do |value, i|
                    css = "cf_#{value.custom_field.id}"
                    m = (i < half ? :left : :right)
                    rows.send m, custom_field_name_tag(value.custom_field), show_value(value), :class => css
                  end
                end
              elsif key == "1"
                issue_fields_rows do |rows|
                  values.each do |value|
                    css = "cf_#{value.custom_field.id}"
                    rows.send :left, custom_field_name_tag(value.custom_field), show_value(value), :class => css
                  end
                  s << content_tag('div', rows.left.reduce(&:+).gsub('<div class="value">', '<div class="value" style="overflow-x:auto;">').gsub('<p>', '<p style="margin:0">').html_safe, class: 'splitcontent')
                end
              end
            end
          end
          s.gsub(content_tag('div', '', class: 'splitcontentleft'), '').html_safe
        end
      end
    end
  end
end

unless IssuesHelper.included_modules.include?(RedmineCustomFieldViews::Patches::RedmineCustomFieldViewsIssuesHelperPatch)
  IssuesHelper.send(:include, RedmineCustomFieldViews::Patches::RedmineCustomFieldViewsIssuesHelperPatch)
end

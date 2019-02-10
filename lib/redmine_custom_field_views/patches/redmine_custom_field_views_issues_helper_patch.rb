require_dependency 'issues_helper'

module RedmineCustomFieldViews
  module IssuesHelperPatch

    # Under Redmine 3.3.x
    def render_custom_fields_rows(issue)
      s = ""
      allocation_columns(issue.custom_field_values).each do |columns_by_type|
        columns_by_type.each do |key, values|
          if key == "2"
            half = (values.size / 2.0).ceil
            s << issue_fields_rows do |rows|
              values.each_with_index do |value, idx|
                css = "cf_#{value.custom_field.id}"
                m = (idx < half ? :left : :right)
                rows.send m, custom_field_name_tag(value.custom_field), show_value(value), class: css
              end
            end
          elsif key == "1"
            issue_fields_rows do |rows|
              values.each do |value|
                css = "cf_#{value.custom_field.id}"
                rows.send :left, custom_field_name_tag(value.custom_field), show_value(value), class: css
              end
              s << content_tag('div', rows.left.reduce(&:+).gsub('<div class="value">', '<div class="value" style="overflow-x:auto;">').gsub('<p>', '<p style="margin:0">').html_safe, class: 'splitcontent')
            end
          end
        end
      end
      s.gsub(content_tag('div', '', class: 'splitcontentleft'), '').html_safe
    end

    # Over Redmine 3.4.x
    def render_half_width_custom_fields_rows(issue)
     render_custom_fields_rows(issue)
    end

    # Over Redmine 3.4.x
    def render_full_width_custom_fields_rows(issue)
    end
  end
end

IssuesHelper.prepend(RedmineCustomFieldViews::IssuesHelperPatch)

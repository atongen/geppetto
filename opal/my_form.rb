class MyForm

  def initialize
    update

    update_fields.on(:click) { update }
  end

  def update
    toggle_child(ruby_versions, ruby_type.checked?)
    toggle_child(jruby_versions, jruby_type.checked?)
    toggle_child(php_extras, php_version != '')
    toggle_child(java_versions, java_type != '')
  end

  def toggle_child(child, criteria)
    #TODO: Disable/enable fields in child sections
    child.toggle(criteria)
  end

  def ruby_type
    @ruby_type ||= Element.find('#virt-ruby-type-ruby')
  end

  def jruby_type
    @jruby_type ||= Element.find('#virt-ruby-type-jruby')
  end

  def php_version
    php_versions.filter(':checked').value
  end

  def php_versions
    @php_versions ||= Element.find('input[name=virt\[php_version\]]')
  end

  def php_extras
    @php_extras ||= Element.find('#php-extras-options')
  end

  def java_type
    java_fields.filter(':checked').value
  end

  def java_fields
    @java_fields ||= Element.find('input[name=virt\[java_type\]]')
  end

  def java_versions
    @java_versions ||= Element.find('.java-version-options')
  end

  def ruby_versions
    @ruby_versions ||= Element.find('.ruby-version-options')
  end

  def jruby_versions
    @jruby_versions ||= Element.find('.jruby-version-options')
  end

  def update_fields
    @update_fields ||= Element.find('.selection-parent input:radio')
  end
end

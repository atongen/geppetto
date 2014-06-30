class Element
  def checked?
    prop('checked')
  end
end

class MyForm

  def initialize
    update

    update_fields.on(:click) { update }
  end

  def update
    if ruby_type.checked?
      ruby_versions.show
    else
      ruby_versions.hide
    end

    if jruby_type.checked?
      jruby_versions.show
    else
      jruby_versions.hide
    end

    php_extras.toggle(php_version != '')

    if java_type != ""
      java_versions.show
    else
      java_versions.hide
    end
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

Document.ready? do
  my_form = MyForm.new
end


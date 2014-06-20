class Element
  def checked?
    prop('checked')
  end
end

class MyForm

  def initialize
    update
    ruby_type.on(:click) { update }
    jruby_type.on(:click) { update }
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
  end

  def ruby_type
    @ruby_type ||= Element.find('#virt-ruby-type-ruby')
  end

  def jruby_type
    @jruby_type ||= Element.find('#virt-ruby-type-jruby')
  end

  def ruby_versions
    @ruby_versions ||= Element.find('.ruby-version-options')
  end

  def jruby_versions
    @jruby_versions ||= Element.find('.jruby-version-options')
  end

end

Document.ready? do
  my_form = MyForm.new
end


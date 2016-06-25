module Jekyll
  class WarningTag < Liquid::Block
    def render(context)
      "<div class='warning'>#{super}</div>"
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::WarningTag)
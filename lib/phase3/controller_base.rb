require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      file = File.read("../../views/#{self.to_s}/#{template_name}.html.erb")
      erb_file = ERB.new(file).result(binding)
      render_content erb_file "text/html"
    end
  end
end

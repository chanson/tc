module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def link_to_void(*args, &block)
    name = args.first.is_a?(::Hash) ? '' : args.first
    html_opts = args.extract_options!.symbolize_keys
    html_opts.merge! :href => 'javascript:void(0)'
    content_tag :a, name, html_opts, &block
  end
end

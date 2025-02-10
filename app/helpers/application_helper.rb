module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(
      filter_html: true, # Prevents raw HTML from being rendered.
      hard_wrap:   true # Wraps paragraphs in <br> tags for newlines.
    )
    options = {
      autolink:            true,
      tables:              true,
      fenced_code_blocks:  true,
      no_intra_emphasis:   true,
      strikethrough:       true,
      lax_spacing:         true,
      space_after_headers: true
    }
    md = Redcarpet::Markdown.new(renderer, options)
    md.render(text).html_safe
  end
end

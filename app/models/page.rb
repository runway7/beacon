class Page < ActiveRecord::Base
  validates_presence_of :title, :url

  before_save :pull_content
  before_save :clean_main_url
  
  def tags_display
    (tags || []).join(', ')
  end

  def tags_display=(value)
    self.tags = split(value).map(&:parameterize).uniq
  end

  def aliases_display
    (aliases || []).map{ |als| "/#{als}" }.join(', ')
  end

  def aliases_display=(value)
    self.aliases = split(value).map{ |als| clean_url als }.uniq
  end  

  class HTMLwithAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language, options: {encoding: 'utf-8'})
    end
  end

  def rendered_content
    markdown = Redcarpet::Markdown.new(HTMLwithAlbino.new(render_options={:with_toc_data => true}),
        autolink: true, no_intra_emphasis: true, fenced_code_blocks: true, lax_spacing: true)
    markdown.render(content).html_safe
  end

  private 

  def pull_content
    self.content = HTTParty.get(source).body
  end

  def clean_url(url)
    clean_list(url.split('/')).map(&:parameterize).join('/')
  end

  def split(value)
    clean_list value.split(',')
  end

  def clean_list(list)
    list.map(&:strip).reject(&:blank?)
  end

  def clean_main_url
    self.url = clean_url url
  end
end

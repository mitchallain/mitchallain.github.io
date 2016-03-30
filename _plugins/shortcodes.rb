
class ImageTag < Liquid::Tag
  def initialize(tag_name, args, tokens)
    super
    @src, @width, @height, @option = args.split
  end

  def render(context)
    if @option == 'fw'
      <<-MARKUP.strip
        <figure class="fullwidth"><amp-img width="#{@width}" height="#{@height}" layout="responsive" src="#{@src}"></amp-img></figure>
      MARKUP
    elsif @option == 'raw'
      <<-MARKUP.strip
        <amp-img width="#{@width}" height="#{@height}" src="#{@src}"></amp-img>
      MARKUP
    else
      <<-MARKUP.strip
        <figure><amp-img width="#{@width}" height="#{@height}" layout="responsive" src="#{@src}"></amp-img></figure>
      MARKUP
    end
  end
end

class YoutubeTag < Liquid::Tag
  def initialize(tag_name, args, tokens)
    super
    @youtube_id, @width, @height, @option = args.split
  end

  def render(context)
    if @option == 'fw'
      <<-MARKUP.strip
        <figure class="fullwidth"><amp-youtube data-videoid="#{@youtube_id}" layout="responsive" width="#{@width}" height="#{@height}"></amp-youtube></figure>
      MARKUP
    elsif @option == 'raw'
      <<-MARKUP.strip
        <amp-youtube data-videoid="#{@youtube_id}" layout="responsive" width="#{@width}" height="#{@height}"></amp-youtube>
      MARKUP
    else
      <<-MARKUP.strip
        <figure><amp-youtube data-videoid="#{@youtube_id}" layout="responsive" width="#{@width}" height="#{@height}"></amp-youtube></figure>
      MARKUP
    end
  end
end

class SideNoteTag < Liquid::Tag
  def initialize(tag_name, args, tokens)
    super
    @tag_identifier = args.split[0]
    @sidenote = args.split.drop(1).join(" ")
  end

  def render(context)
    <<-MARKUP.strip
      <span id="#{@tag_identifier}" class="margin-toggle sidenote-number"></span>
      <span class="sidenote">#{@sidenote}</span>
    MARKUP
  end
end

class MarginNoteTag < Liquid::Block
  def initialize(tag_name, args, tokens)
    super
    @tag_identifier = args.split[0]
  end

  def render(context)
    <<-MARKUP.strip
      <span class="marginnote">#{super.strip}</span>
    MARKUP
  end
end

Liquid::Template.register_tag('image', ImageTag)
Liquid::Template.register_tag('youtube', YoutubeTag)
Liquid::Template.register_tag('sidenote', SideNoteTag)
Liquid::Template.register_tag('marginnote', MarginNoteTag)
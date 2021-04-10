module ApplicationHelper
  def default_meta_tags
    {
      site: Settings.site.name,
      description: Settings.site.description,
      reverse: true,
      separator: '-',
      canonical: request.original_url,
      og: default_og,
      twitter: default_twitter
    }
  end

  def default_og
    {
      title: :title,
      description: :description,
      type: Settings.site.meta.ogp.type,
      url: request.original_url,
      image: page_og_image,
      site_name: Settings.site.name,
      locale: 'ja_JP'
    }
  end

  def page_og_image
    @page_image || image_url(Settings.site.meta.ogp.image_path)
  end

  def default_twitter
    {
      card: 'summary'
    }
  end
end

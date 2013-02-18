module RacesHelper

  def race_attributes_show_column(record)
    content_tag :ul do
      record.race_attributes.each do |race_attribute|
        concat content_tag :li, "#{h(race_attribute.value)} #{h(race_attribute.attribute.name)}"
      end
    end
  end

  def arbitrary_attributes_show_column(record)
    if record.arbitrary_attributes > 0
      t(:arbitrary_attributes_show_description,
        :name => pluralize(2, record.name),
        :number => record.arbitrary_attributes)
    else
      t(:none)
    end
  end

  def race_feats_show_column(record)
    content_tag :ul do
      record.feats.each do |feat|
        concat content_tag :li, "<b>#{h(feat.name)}:</b> #{h(feat.benefits)}".html_safe
      end
    end
  end
end
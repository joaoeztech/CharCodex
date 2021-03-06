module MonstersHelper

  def dimension_form_column(record, options)
    options[:selected] = record.dimension if record.dimension
    select :record, :dimension, [[t(:small), 0], [t(:medium), 1], [t(:large), 2], [t(:huge), 3]], options, options
  end

  def dimension_column(record)
    size_h = {0 => t(:small), 1 => t(:medium), 2 => t(:large), 3 => t(:huge)}
    size_h[record.dimension]
  end
end

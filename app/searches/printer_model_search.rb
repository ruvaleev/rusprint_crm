require "searchlight/adapters/action_view"

class PrinterModelSearch < Searchlight::Search
  include Searchlight::Adapters::ActionView

  def base_query
    PrinterServiceGuide.all
  end

  def search_model_like
    result = query.where("model LIKE ?", "%#{model_like}%")
  end

end
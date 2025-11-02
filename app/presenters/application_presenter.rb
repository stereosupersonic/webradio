require "delegate"

class ApplicationPresenter < SimpleDelegator
 include ActionView::Helpers
  alias_method :object, :__getobj__

  def self.wrap(collection)
    collection.map { |elem| new(elem) }
  end

  def helpers
    ApplicationController.helpers
  end

  alias_method :h, :helpers
  alias_method :o, :object
end

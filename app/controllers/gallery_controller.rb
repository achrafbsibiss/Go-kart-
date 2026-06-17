class GalleryController < ApplicationController
  def index
    @category = params[:category].presence_in(GalleryItem.categories.keys)
    scope = GalleryItem.ordered
    scope = scope.where(category: @category) if @category
    @items = scope
    @categories = GalleryItem.categories.keys
  end
end

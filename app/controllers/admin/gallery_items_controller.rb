module Admin
  class GalleryItemsController < ResourceController
    private

    def permitted_attributes
      [
      "title",
      "description",
      "media_kind",
      "category",
      "video_url",
      "position",
      "featured",
      "image"
      ]
    end
  end
end

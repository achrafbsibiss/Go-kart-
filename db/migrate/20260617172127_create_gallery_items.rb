class CreateGalleryItems < ActiveRecord::Migration[7.2]
  def change
    create_table :gallery_items do |t|
      t.string :title
      t.text :description
      t.integer :media_kind
      t.string :video_url
      t.integer :category
      t.integer :position
      t.boolean :featured

      t.timestamps
    end
  end
end

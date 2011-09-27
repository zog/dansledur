class AddImageToMedia < ActiveRecord::Migration

  def change
    add_column :media, :image_file_name,    :string
    add_column :media, :image_content_type, :string
    add_column :media, :image_file_size,    :integer
    add_column :media, :image_updated_at,   :datetime
  end
end

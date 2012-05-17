class AddUrlToMedia < ActiveRecord::Migration
  def change
    add_column :media, :url, :string
    add_column :media, :fetched_at, :datetime
    Medium.all.each do |m| m.update_attribute :fetched_at, Time.now end
  end
end

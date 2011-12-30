class AddCountsToMedia < ActiveRecord::Migration
  def change
    change_table(:media) do |t|
      t.integer :views_count 
    end
  end
end

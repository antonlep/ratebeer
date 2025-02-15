class RemoveOldStyleFromBeers < ActiveRecord::Migration[8.0]
  def change
    remove_column :beers, :old_style
  end
end

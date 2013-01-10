class CreatePages < ActiveRecord::Migration
  def change    
    create_table :pages do |t|
      t.string :title
      t.string :description
      t.string :tags, array: true
      t.text :content
      t.string :source
      t.timestamps
      t.string :url
      t.string :aliases, array: true
    end
  end
end

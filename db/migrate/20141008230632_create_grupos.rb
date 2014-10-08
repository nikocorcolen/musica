class CreateGrupos < ActiveRecord::Migration
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.integer :like
      t.integer :like_pais

      t.timestamps
    end
  end
end

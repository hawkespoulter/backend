class CreateJwtDenylists < ActiveRecord::Migration[6.0]
  def change
    create_table :jwt_denylists do |t|
      t.string :jti, null: false
      t.timestamps
    end
    add_index :jwt_denylists, :jti
  end
end

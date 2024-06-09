class AddNewProgramToTranser < ActiveRecord::Migration[5.2]
  def change
  	add_column :transfers, :new_program, :string
  end
end

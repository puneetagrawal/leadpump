class CreateTemporaryData < ActiveRecord::Migration
  def change
    create_table :temporary_data do |t|
      t.string :associate
      t.string :fn
      t.string :add
      t.string :zp
      t.string :ag
      t.string :ct
      t.string :em
      t.string :ph
      t.string :gst
      t.string :prg
      t.string :st
      t.string :cex
      t.string :hc
      t.string :fg
      t.timestamps
    end
  end
end

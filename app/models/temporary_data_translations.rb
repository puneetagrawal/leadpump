class TemporaryDataTranslations < ActiveRecord::Base
  def up
  	translates :associate,:fn, :add, :zp, :ag, :ct, :em, :ph, :gst, :prg,
   :st, :cex, :hc, :fg
    TemporaryData.create_translation_table!({
      associate: :string,
      fn: :string,
      add: :string,
      zp: :string,
      ag: :string,
      ct: :string,
      em: :string,
      ph: :string,
      gst: :string,
      prg: :string,
      st: :string,
      cex: :string,
      hc: :string,
      fg: :string,
    }, {
      migrate_data: true
    })
  end

  def down
    TemporaryData.drop_translation_table! migrate_data: true
  end
end

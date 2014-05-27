class TemporaryData < ActiveRecord::Base
  attr_accessible :associate,:fn, :add, :zp, :ag, :ct, :em, :ph, :gst, :prg,
   :st, :cex, :hc, :fg

  translates :associate,:fn, :add, :zp, :ag, :ct, :em, :ph, :gst, :prg,
   :st, :cex, :hc, :fg
end

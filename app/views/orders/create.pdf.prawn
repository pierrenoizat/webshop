
require 'prawn'

pdf.font "Helvetica"
pdf.font.size = 13
pdf.text "Name: #{@order.name}", :size => 16, :style => :bold, :spacing => 4
pdf.text "Author: #{@order.total}", :spacing => 16
pdf.text @order.description
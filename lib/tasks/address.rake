
require "rubygems"
require 'bundler/setup'
require 'spreadsheet'
require "csv"
require "pry"
require "active_support/all"
require "active_model"
require "mechanize"

def relative_path(path)
  File.expand_path(path, File.dirname(__FILE__))
end

require relative_path("ask.rb")

include Ask

namespace :address do
  desc "Add new payment addresses"
  task :add => :environment do
    address = ask('Please insert new address:')
    # @adresse = Adresse.create(:available => true)
    # @adresse.btc_address = address
    #@adresse.save
    address # rake task useless since we switched to deterministic wallet
  end # end task add
 
  desc "Make used addresses available for new payments"
  task :free => :environment do
   # @array= Adresse.find_all_by_available(false)
   # @array.each do |address|
   #  address.update_attributes(:available => true)
   #  @array_of_invoices = Invoice.find_all_by_btc_address(address.btc_address)
   #  @array_of_invoices.each do |invoice|
   #     invoice.update_attributes(:btc_address => "")
   # rake task useless since we switched to deterministic wallet
   #   end
   # end
   
   # @array= Adresse.find_all_by_available(true)
   # @array.each do |address|
   #   @array_of_invoices = Invoice.find_all_by_btc_address(address.btc_address)
   #   @array_of_invoices.each do |invoice|
   #      invoice.update_attributes(:btc_address => "")
   #    end
   # end
   
  end # end task free
 
end # end namespace address
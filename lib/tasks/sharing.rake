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

namespace :sharing do
  desc "Split secret into 3 shares, 2 of which will be required to recombine the secret"
  task :split => :environment do
    #secret = ask('Please insert secret:')
    shares = `./ssss-split -t 2 -n 3`
    $string = STDIN.gets.chomp!
    
  end
 
  desc "Combine 2 out of 3 shares"
  task :combine => :environment do
   share_1 = `./ssss-combine -t 2`
   $string = STDIN.gets.chomp!
   $string = STDIN.gets.chomp!
   #puts $string
  end
 
end
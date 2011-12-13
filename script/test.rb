#!/usr/bin/ruby
require 'rubygems'
require 'bundler/setup'
require 'forever'
require 'nfc'

def getTag
    # tag = NFC.instance.find
    File.open('tagfile', 'r') do |f|
        f.readline
    end
end

Forever.run do
        puts getTag
        #if current != update current
        # if current != checkd db and call xbmc with hash
end

#sudo pcscd -fd

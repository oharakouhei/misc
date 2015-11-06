#!/usr/bin/env ruby
# coding: utf-8

#
# Railsにて、すでに存在してデータも入っているテーブルの
# img_filenameカラムの値をすべて更新するスクリプト(csvは使ってなし)
#
require 'csv'
require 'yaml'
require 'optparse'
require "active_record"

params = ARGV.getopts('', 'csv:hoge.csv', 'ENV:development', 'RAILS_ROOT:/path/to/project/')
p params

database_yml_file = params['RAILS_ROOT'] + 'config/database.yml'
p database_yml_file
config = YAML.load_file( database_yml_file )
raise ArgumentError, 'ENVが設定されていません'            if params['ENV'].nil?
raise ArgumentError, 'RAILS_ROOTが指定されていません'     if params['RAILS_ROOT'].nil?
raise ArgumentError, 'database.ymlを読み出せませんでした' if config[params['ENV']].nil?
# raise ArgumentError, 'csvファイルが存在しません'          unless File.exists?(params['csv'])

config[params['ENV']]['database'] = params['RAILS_ROOT'] + config[params['ENV']]['database']
ActiveRecord::Base.establish_connection( config[params['ENV']] )
class Bukken < ActiveRecord::Base
end

bukkens = Bukken.all
bukkens.each do |bukken|
    new_img_filename = "sc_chiyoda/" << bukken.img_filename
    bukken.update_attribute(:img_filename, new_img_filename)
end

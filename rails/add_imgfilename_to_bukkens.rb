#!/usr/bin/env ruby
# coding: utf-8

#
# Railsにて、すでに存在してデータも入っているテーブルに
# 新しく追加したimg_filenameカラムをcsvファイルからデータ挿入するスクリプト
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
raise ArgumentError, 'csvファイルが存在しません'          unless File.exists?(params['csv'])

config[params['ENV']]['database'] = params['RAILS_ROOT'] + config[params['ENV']]['database']
ActiveRecord::Base.establish_connection( config[params['ENV']] )
class Bukken < ActiveRecord::Base
end

# カラム名をスペース空けで表す
column = %w(id name img_filename)
CSV.foreach(params['csv']) do |row|
  # 一行を全部hashに入れる
  row_hash = {}
  row.each_with_index do |r,idx|
    row_hash[column[idx]] = r
  end

  bukken = Bukken.find_by_id(row_hash['id'])
  if !bukken.nil?
    bukken.update_attribute(:img_filename, row_hash['img_filename'])
  end
end


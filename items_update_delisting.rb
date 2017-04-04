# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'

module Youzan
  class ItemsUpdateDelisting
    attr_reader :raw_json
    
    def initialize(filter_arr)
      @raw_json = raw_json
      #parse_json
    end

    def yz_arr
      JSON.parse(raw_json)
    end
    
    def items_arr
      yz_arr["response"]["items"]
    end

    def parse_json 
      skus_array = Array.new
      items_arr.each do |item|
        item["skus"].each do |sku|
          if out_of_date?(sku["properties_name"])
            skus_array.push item["num_iid"], item["title"], item["detail_url"], item["skus"] #sku_filter(item["skus"])
            break;
          end
        end 
      end
      #for check items number ritht
      skus_array.push items_arr.count
      skus_array
    end

    private
    
    #out of date?
    def out_of_date? sku
      if  sku  =~ /出行日期/
        #chineseMonth = `date "+%m月"`.chomp
        month = `date "+%m"`.to_i
        day =  `date "+%d"`.to_i
        ### bug hidden. $1 change depend on proccess order
        sku =~  /(\d+)月/
        month_schedule = $1.to_i
        sku =~  /(\d+)日/
        day_schedule = $1.to_i
        
        if month > month_schedule
          return true
        elsif month = month_schedule && day > day_schedule
          return true
        end
      end
    end
    
    
  end
end







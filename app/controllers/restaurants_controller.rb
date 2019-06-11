require 'json'
require 'net/https'
require "uri"

class RestaurantsController < ApplicationController
  def index

  end

  def search
    latitude = params[:latitude]
    longitude = params[:longitude]
    range = params[:range]
    words = params[:word]
    data = {
      "keyid": "c64de82187c33b325c4ed6c51f3979ef",
      "latitude": latitude,
      "longitude": longitude,
      "range": range,
      "freeword": words,
      "hit_per_page": 100
    }
    
    query = data.to_query
    uri = URI("https://api.gnavi.co.jp/RestSearchAPI/?"+query)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    res_data = Hash.from_xml(res.body)
    if res_data.has_key?("response")
      datas = res_data["response"]["rest"]
      # binding.pry
      if datas.kind_of?(Array)
        @restaurants = Kaminari.paginate_array(datas).page(params[:page]).per(10)
      else
        @restaurant = datas
      end
    else
      flash[:danger] = res_data["gnavi"]["error"]["message"]
      redirect_to root_url
    end
  end

  def data
    id = params[:id]
    data = {
      "keyid": "c64de82187c33b325c4ed6c51f3979ef",
      "id": id
    }
    query = data.to_query
    uri = URI("https://api.gnavi.co.jp/RestSearchAPI/?"+query)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    res_data = Hash.from_xml(res.body)
    restaurant = res_data["response"]["rest"]
    @image, @name, @tel = restaurant["image_url"]["shop_image1"], restaurant["name"], restaurant["tel"]
    @pr = restaurant["pr"]["pr_long"]? restaurant["pr"]["pr_long"].gsub("<BR>", " ") : "PRはありません"
    time = restaurant["opentime"]? restaurant["opentime"].gsub("<BR>", " ") : "営業時間は不明です"
    @opentime =[]
    if time
      time = time.split(" ")
      time.each_with_index do |opentime, i|
        @opentime[i] = opentime
      end
    end

    if restaurant["address"]
      location = restaurant["address"].split(" ")
      @postal_code, @address = location[0], location[1]
    end
    # binding.pry
    @map_url = "https://maps.google.com/maps?q=#{restaurant["latitude"]},#{restaurant["longitude"]}"
  end
end

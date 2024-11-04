require 'nokogiri'
require 'open-uri'
require 'json'

url = "https://www.digimart.net/search?category12Id=3&brandnames=Elrick&keywordAnd=Elrick+Gold+Series+E-volution+4&productTypes=USED"
html = URI.open(url).read
doc = Nokogiri::HTML(html)
items = doc.css('.itemSearchBlock.itemSearchListItem').map do |item|
  item_date_info = item.css('.itemDateInfo').text
  matched = item_date_info.match /商品ID：(.+)\n登録：(.{10})/
  product_id = matched[1]
  registered_date = matched[2]
  title = item.css('.ttl').text
  url = URI.join('https://www.digimart.net/', item.css('.ttl a').attribute('href').value).to_s
  price = item.css('.itemState .price').first.text.gsub(/[^\d]/, "").to_i
  {
    product_id:,
    registered_date:,
    title:,
    url:,
    price:
  }
end.sort_by { Date.parse(_1[:registered_date]) }

File.write('digimart.json', JSON.pretty_generate(items))

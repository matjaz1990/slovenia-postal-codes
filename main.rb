require 'httparty'
require 'nokogiri'

class Scrapper
  def initialize
    @urls = [
      "http://www.postnestevilke.com/postne-stevilke-1000-1434.php",
      "http://www.postnestevilke.com/postne-stevilke-2000-2394.php",
      "http://www.postnestevilke.com/postne-stevilke-3000-3342.php",
      "http://www.postnestevilke.com/postne-stevilke-4000-4294.php",
      "http://www.postnestevilke.com/postne-stevilke-5000-5297.php",
      "http://www.postnestevilke.com/postne-stevilke-6000-6333.php",
      "http://www.postnestevilke.com/postne-stevilke-8000-8362.php",
      "http://www.postnestevilke.com/postne-stevilke-9000-9265.php"
    ]

    @post_offices = []
  end

  def run()
    @urls.each do |url|
      html = Nokogiri::HTML(HTTParty.get(url))
      scrape_page(html)
    end
  end

  def scrape_page(html)
    ps = html.css(".contpost > div p")
    puts ps.count
    ps_count = ps.count - 2

    (1..ps_count).each do |i|
      strong = ps[i].css("strong")
      (0..strong.count-1).each do |j|
        code = strong[j].text
        name = strong[j].next.text
        puts "#{code} -> #{name}"
        @post_offices << {code: code, name: name, country: 'SI'}
      end
    end

    puts "-----"
  end

  def to_csv
    CSV.generate(headers: true) do
      csv << ["name", "postal_code", "country_code"]

      @post_offices.each do |po|
        csv << [po.name, po.code, po.country]
      end
    end
  end

end

x = Scraper.new().run
File.write('postal_codes_si.csv', x.to_csv)
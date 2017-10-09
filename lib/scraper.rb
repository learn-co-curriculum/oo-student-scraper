require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    a = []
    doc.css("div.student-card a").collect.each_with_index do |student, index|
      a << {:name => "#{student.css("h4.student-name")[0].text}",
      :location => "#{student.css("p.student-location")[0].text}",
      :profile_url => "#{student.attr('href')}" }
      
    end
    a
  end

  def self.scrape_profile_page(profile_url)
    
  end

end


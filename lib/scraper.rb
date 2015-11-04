require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".card-text-container").each do |container|
        student_name = container.css(".student-name").text
        student_location = container.css(".student-location").text
        students << {name: student_name, location: student_location}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    
    student[:twitter] = profile_page.css(".social-icon-container").children.css("a")[0].attribute("href").value
    student[:linkedin] = profile_page.css(".social-icon-container").children.css("a")[1].attribute("href").value
    student[:github] = profile_page.css(".social-icon-container").children.css("a")[2].attribute("href").value
    student[:blog] = profile_page.css(".social-icon-container").children.css("a")[3].attribute("href").value

    student[:profile_quote] = profile_page.css(".profile-quote").text
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text
    
    student
  end

end


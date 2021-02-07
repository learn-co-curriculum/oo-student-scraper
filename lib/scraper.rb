require 'net/http'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    uri = URI.parse(index_url)
    response = Net::HTTP.get_response(uri)    
    html = Nokogiri::HTML(response.body)

    students = []
    html.css("div.student-card").each do |card|
      student = {}
      student[:name] = card.css("h4")[0].text
      student[:location] = card.css("p")[0].text
      student[:profile_url] = card.css("a").attribute("href").value
      students << student
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    profile = {}

    uri = URI.parse(profile_url)
    response = Net::HTTP.get_response(uri)    
    html = Nokogiri::HTML(response.body)

    socials = html.css("div.social-icon-container")[0]
    
    socials.css("a").each do |link|
      href = link.attribute("href").value
      if href.include?("twitter")
        profile[:twitter] = href
      elsif href.include?("linkedin")
        profile[:linkedin] = href
      elsif href.include?("github")
        profile[:github] = href
      elsif href.include?("youtube")
        profile[:youtube] = href
      else
        profile[:blog] = href
      end
    end

    profile[:profile_quote] = html.css("div.profile-quote")[0].text
    profile[:bio] = html.css("div.bio-content")[0].css("p")[0].text unless  html.css("div.bio-content")[0].css("p")[0] == nil

    profile
  end

end


require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'

class CommandLineInteface
  INDEX_URL = "http://learn-co-curriculum.github.io/student-scrape-site/"
  BASE_PROFILE_URL = "http://learn-co-curriculum.github.io/student-scrape-site/profile.html"

  def run
    self.make_students
    self.add_attributes_to_students
    self.display_students
  end

  def make_students
    students_array = Scraper.scrape_index_page(INDEX_URL)
    Student.create_from_collection(students_array)
  end

  def add_attributes_to_students
    Student.all.each do |student|
      profile_url = BASE_PROFILE_URL
      # + "#{student.name}"
      attributes = Scraper.scrape_profile_page(profile_url)
      student.add_student_attributes(attributes)
    end
  end

  def display_students
    Student.all.each do |student|
      puts "#{student.name.upcase}:"
      puts "  #{student.location}"
      puts "  #{student.profile_quote}"
      puts "  #{student.bio}"
      puts "  #{student.twitter}"
      puts "  #{student.linkedin}"
      puts "  #{student.github}"
      puts "  #{student.blog}"
      puts "----------------------"
    end
  end

end
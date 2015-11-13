require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'

class CommandLineInteface
  BASE_URL = "http://students.learn.co"

  def run
    make_students
    add_attributes_to_students
    display_students
  end

  def make_students
    students_array = Scraper.scrape_index_page(BASE_URL)
    Student.create_from_collection(students_array)
  end

  def add_attributes_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(student.profile_url)
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

require "spec_helper"

describe "Scraper" do

  let!(:student_index_array) {[{:name=>"Alex Patriquin", :location=>"New York, NY"},
 {:name=>"Bacon McRib", :location=>"Kansas City, MO"},
 {:name=>"Alisha McWilliams", :location=>"San Francisco, CA"},
 {:name=>"Daniel Fenjves", :location=>"Austin, TX"},
 {:name=>"Arielle Sullivan", :location=>"Chicago, IL"},
 {:name=>"Sushanth Bhaskarab", :location=>"Portland, OR"},
 {:name=>"Sushanth Bhaskarab", :location=>"Portland, OR"}]}

 let!(:student_hash) {{:twitter=>"someone@twitter.com",
 :linkedin=>"someone@linkedin.com",
 :github=>"someone@github.com",
 :blog=>"someone@blog.com",
 :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
 :bio=>
  "I was in southern California for college (sun and In-n-Out!), rural Oregon for high school (lived in a town with 1500 people and 3000+ cows), and Tokyo for elementary/middle school."}}

  describe "#scrape_index_page" do 
    it "is a class method that scrapes the student index page and a returns an array of hashes in which each hash represents one student" do 
      VCR.use_cassette('fixtures/index_page') do
        index_url = "http://learn-co-curriculum.github.io/student-scrape-site/"
        scraped_students = Scraper.scrape_index_page(index_url)
        expect(scraped_students).to be_a(Array)
        expect(scraped_students.first).to have_key(:location)
        expect(scraped_students.first).to have_key(:name)
        expect(scraped_students).to match(student_index_array)
      end
    end
  end

  describe "#scrape_profile_page" do 
    it "is a class method that scrapes a student's profile page and returns a hash of attributes describing an individual student" do 
      VCR.use_cassette('fixtures/profile_page') do
        profile_url = "http://learn-co-curriculum.github.io/student-scrape-site/profile.html"
        scraped_student = Scraper.scrape_profile_page(profile_url)
        expect(scraped_student).to be_a(Hash)
        expect(scraped_student).to match(scraped_student)
      end
    end
  end
end

require "spec_helper"

describe "Scraper" do

  let!(:student_index_array) {[{:name=>"Joe Burgess", :location=>"New York, NY", :profile_url=>"http://students.learn.co/students/joe-burgess.html"},
                               {:name=>"Mathieu Balez", :location=>"New York, NY", :profile_url=>"http://students.learn.co/students/mathieu-balez.html"},
                               {:name=>"Diane Vu", :location=>"New York, NY", :profile_url=>"http://students.learn.co/students/diane-vu.html"}]}

  let!(:student_joe_hash) {{:twitter=>"https://twitter.com/jmburges",
                            :linkedin=>"https://www.linkedin.com/in/jmburges",
                            :github=>"https://github.com/jmburges",
                            :blog=>"http://joemburgess.com/",
                            :profile_quote=>"\"Reduce to a previously solved problem\"",
                            :bio=>
  "I grew up outside of the Washington DC (NoVA!) and went to college at Carnegie Mellon University in Pittsburgh. After college, I worked as an Oracle consultant for IBM for a bit and now I teach here at The Flatiron School."}}

  let!(:student_mat_balez) {{:twitter=>"http://twitter.com/matbalez",
                             :linkedin=>"",
                             :github=>"http://www.github.com/matbalez",
                             :profile_quote=>"",
                             :bio=>
  "I was born in Northern Ontario where I grew up riding snowmobiles."}}

  describe "#scrape_index_page" do
    it "is a class method that scrapes the student index page and a returns an array of hashes in which each hash represents one student" do
      VCR.use_cassette('fixtures/index_page') do
        index_url = "http://students.learn.co"
        scraped_students = Scraper.scrape_index_page(index_url)
        expect(scraped_students).to be_a(Array)
        expect(scraped_students.first).to include(:location, :name, :profile_url)
        expect(scraped_students).to match(student_index_array)
      end
    end
  end

  describe "#scrape_profile_page" do
    context "after scrapping a completed student profile page" do
      it "returns a hash of attributes that describes a student" do
        VCR.use_cassette("fixtures/joe-burgess-profile") do
          profile_url = "http://students.learn.co/students/joe-burgess.html"
          scraped_student = Scraper.scrape_profile_page(profile_url)
          expect(scraped_student).to include(:twitter, :linkedin, :github, :blog, :profile_quote, :bio)
          expect(scraped_student[:twitter]).to include("https://twitter.com")
          expect(scraped_student[:linkedin]).to include("https://www.linkedin.com/in/")
          expect(scraped_student[:github]).to include("https://github.com")
        end
      end
    end

    context "after scrapping an uncomplete student profile page" do
      it "can handle incomplete links" do
        VCR.use_cassette('fixtures/mat-balez-profile') do
        profile_url = "http://students.learn.co/students/mathieu-balez.html"
        scraped_student = Scraper.scrape_profile_page(profile_url)
        expect(scraped_student).to include(:twitter, :linkedin, :github, :blog, :profile_quote, :bio)
        expect(scraped_student).to match(scraped_student)
        end
      end
    end
  end
end

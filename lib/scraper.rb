require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    students = []

    doc.css(".student-card").each do |student|
      student_hash = {
        :name => student.css("h4.student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students << student_hash
    end #ends each iteration

    students #returns array of hashes

    #notes for scraping
    # students: doc.css(".student-card")
    # name: student.css("h4.student-name").text
    # location: student.css(".student-location").text
    # profile_url: student.css("a").attribute("href").value
  end #end self.scrape_index_page

  def self.scrape_profile_page(profile_slug)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    # student[:twitter] = profile_page.css(".social-icon-container").children.css("a")[0].attribute("href").value
    # # if profile_page.css(".social-icon-container").children.css("a")[0]
    # student[:linkedin] = profile_page.css(".social-icon-container").children.css("a")[1].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[1]
    # student[:github] = profile_page.css(".social-icon-container").children.css("a")[2].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[2]
    # student[:blog] = profile_page.css(".social-icon-container").children.css("a")[3].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[3]
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end
  


  # My original version that had no ability to handle profile pages without all the social media links
  # I was tired and hungry to just c/p'ed the solution
  # def self.scrape_profile_page(profile_url)
  #   html = open(profile_url)
  #   doc = Nokogiri::HTML(html)

  #   profile_hash = {
  #     :twitter => doc.css(".social-icon-container a").first.attribute("href").value, 
  #     :linkedin => doc.css(".social-icon-container a")[1].attribute("href").value,
  #     :github => doc.css(".social-icon-container a")[2].attribute("href").value,
  #     :blog => doc.css(".social-icon-container a")[3].attribute("href").value,
  #     :profile_quote => doc.css(".profile-quote").text,
  #     :bio => doc.css(".description-holder p").text
  #   }

  #   #notes for scraping / the indexing won't work if they don't have all 4 social medias
  #   # :twitter => doc.css(".social-icon-container a").first.attribute("href").value 
  #   # :linkedin=> doc.css(".social-icon-container a")[1].attribute("href").value
  #   # :github=> doc.css(".social-icon-container a")[2].attribute("href").value
  #   # :blog=> doc.css(".social-icon-container a")[3].attribute("href").value
  #   # :profile_quote=> doc.css(".profile-quote").text
  #   # :bio=> doc.css(".description-holder p").text

  #   #binding.pry
  # end #ends self.scrape_profile_page

end

#Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html")
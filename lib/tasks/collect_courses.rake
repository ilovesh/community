require 'nokogiri'
require 'open-uri'

namespace :db do
  desc "Fill database with course providers' data"
  task providers: :environment do
    Provider.create!(name: "Udacity",  website: "www.udacity.com")
    Provider.create!(name: "Coursera", website: "www.coursera.org")
    Provider.create!(name: "edX",      website: "www.edx.org")
  end
end

# Fetch Udacity data
namespace :db do
  desc "Fill database with Udacity courses"
  task udacity: :environment do
    provider = Provider.find(1)
    url = "http://www.udacity.com"
    doc = Nokogiri::HTML(open(url))
    doc.css(".crs-lst > a").each do |link|
      course_url = url + link['href']
      page = Nokogiri::HTML(open(course_url))
      name = page.at_css("h1").text.split('(')[0].strip
puts "BEGIN" + "*"*10 + name        
      code = page.at_css('h1 span').text
      instructor = page.at_css(".course-overview-instructor:nth-child(1) .course-overview-instructor-name").text
      description = page.at_css('.course-overview-description-body p').text
      image_link = page.at_css('img.course-icon')['src']
      prerequisites = page.at_css('.course-overview-give p').text
=begin # cannot find '.overviewButtons p' via Nokogiri
      start_date = page.at_css('.overviewButtons p')
      if start_date
        progress = 1
      else
        start_date = nil
        progress = 0
      end
=end
      subtitle_span = page.at_css('.course-icon-desc-container h2')
      if subtitle_span
        subtitle = subtitle_span.text
      end
      provider.courses.create!(course_url: course_url,
                               name: name,
                               code: code,
                               instructor: instructor,
                               description: description,
                               image_link: image_link,
                               subtitle: subtitle,
                               prerequisites: prerequisites)
puts "FINISH" + "*"*10 + name      
    end
  end
end

# Fetch edX data
namespace :db do
  desc "Fill database with edX courses"
  task edx: :environment do
    provider = Provider.find(2)
    url = "https://edx.org"
    doc = Nokogiri::HTML(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    doc.css(".university-column").each do |column|
      column.css("article").each do |course|
		# Todo: should split the title from the <h2> content by removing the <span> tags
        name = course.at_css("h2").text.split("x ")[1]
puts "BEGIN" + "*"*10 + name
        course_url = url + course.at_css("a")['href']
        page = Nokogiri::HTML(open(course_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        code = page.at_css("span.course-number").text
        university = page.at_css(".intro h1 a").text
        instructor = page.at_css(".teacher h3").text
        description = page.at_css(".about p").text
        image_link = url + page.at_css(".hero img")["src"]
        prerequisites = page.at_css(".prerequisites p").text
        start_date = Date.parse(page.at_css('.start-date').text)
        final_date = Date.parse(page.at_css('.final-date').text)
		
        provider.courses.create!(course_url: course_url,
                                 name: name,
                                 code: code,
                                 university: university,
                                 instructor: instructor,
                                 description: description,
                                 image_link: image_link,
                                 prerequisites: prerequisites,
                                 start_date: start_date,
                                 final_date: final_date)
puts "FINISH" + "*"*10 + name
      end      
    end
  end
end

# Fetch Coursera data
namespace :db do
  desc "Fill database with Coursera courses"
  task coursera: :environment do
    provider = Provider.find(2)
    url = "https://www.coursera.org"
	
	# Read data from a local html file => file located in "project root/db/"
    doc = Nokogiri::HTML(File.open(Rails.root.join "db/coursera.html"))
	doc.css(".coursera-course-listing-box").each do |course|
      
	  course_url = url + course.at_css(".coursera-course-listing-name a")['href']
      #page = Nokogiri::HTML(open(course_url))
      name = course.at_css("h3 a").text
puts "BEGIN" + "*"*10 + " " + name + " " + course_url     
      # code = page.at_css('').text
      instructor = course.at_css('.coursera-course-listing-instructor').text
      # description = page.at_css('').text
      image_link = course.at_css('.coursera-course-listing-icon')['src']
	  
	  # prerequisites = page.at_css('').text
        # start_date = Date.parse(page.at_css('').text)
        # final_date = Date.parse(page.at_css('').text)
		
        # provider.courses.create!(course_url: course_url,
                                 # name: name,
                                 # code: code,
                                 # university: university,
                                 # instructor: instructor,
                                 # description: description,
                                 # image_link: image_link,
                                 # prerequisites: prerequisites,
                                 # start_date: start_date,
                                 # final_date: final_date)
puts "FINISH" + "*"*10 + " " + name   
    end
  end
end

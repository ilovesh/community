require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'

### NOTE: 3 SEMI-TODOs ###

namespace :db do
  desc "Fetch source data"
  task fetch: :environment do
    create_providers
    fetch_from_udacity
    fetch_from_edx
    fetch_from_coursera
  end
end

def create_providers
  Provider.create!(name: "Udacity",  website: "www.udacity.com")
  Provider.create!(name: "Coursera", website: "www.coursera.org")
  Provider.create!(name: "edX",      website: "www.edx.org")
end

###########################
# Fetch Udacity data
###########################
def fetch_from_udacity
puts "*"*5 + "Udacity" + "*"*5
  provider = Provider.find_by_name("Udacity")
  url = "http://www.udacity.com"
  doc = Nokogiri::HTML(open(url))
  doc.css(".crs-lst > a").each do |link|
    course_url = url + link['href']
    # In case of any TimeoutError, check duplication before scraping.
    c = provider.courses.find_by_course_url(course_url)
    if c.nil?
      coming_soon_span = link.at_css('.crs-coming-soon')
      # SEMI-TODO: below is a temporary solution
      #            cannot find '.overviewButtons p' via Nokogiri in the course page
      if coming_soon_span
        start_date = Date.parse("Dec 31 2013 00:00:00 PST")
        duration = 99
      else
        start_date = nil
        duration = 0
      end
      page = Nokogiri::HTML(open(course_url))
      name = page.at_css("h1").text.split('(')[0].strip
  puts "BEGIN" + "*"*10 + name        
      code          = page.at_css('h1 span').text
      instructor    = page.at_css(".course-overview-instructor:nth-child(1) .course-overview-instructor-name").text
      description   = page.at_css('.course-overview-description-body p').text
      image_link    = page.at_css('img.course-icon')['src']
      prerequisites = page.at_css('.course-overview-give p').text
      subtitle_span = page.at_css('.course-icon-desc-container h2')
      if subtitle_span
        subtitle = subtitle_span.text
      end
      provider.courses.create!(course_url:    course_url,
                               name:          name,
                               code:          code,
                               instructor:    instructor,
                               description:   description,
                               image_link:    image_link,
                               subtitle:      subtitle,
                               prerequisites: prerequisites,
                               start_date:    start_date,
                               duration:      duration)
  puts "FINISH" + "*"*10 + name      
    end
  end  
puts "*"*5 + "Udacity OK" + "*"*5 
end

###########################
# Fetch edX data
###########################
def fetch_from_edx
puts "*"*5 + "edX" + "*"*5  
  provider = Provider.find_by_name("edX")
  url = "https://edx.org"
  doc = Nokogiri::HTML(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
  doc.css(".university-column").each do |column|
    column.css("article").each do |course|
      # SEMI-TODO: should split the title from the <h2> content by removing the <span> tags
      name          = course.at_css("h2").text.split("x ")[1]
puts "BEGIN" + "*"*10 + name
      course_url    = url + course.at_css("a")['href']
      # In case of any TimeoutError, check duplication before scraping.
      c = provider.courses.find_by_course_url(course_url)
      if c.nil?
        page          = Nokogiri::HTML(open(course_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        code          = page.at_css("span.course-number").text
        university    = page.at_css(".intro h1 a").text
        instructor    = page.at_css(".teacher h3").text
        description   = page.at_css(".about p").text
        image_link    = url + page.at_css(".hero img")["src"]
        prerequisites = page.at_css(".prerequisites p").text
        start_date    = page.at_css('.start-date').text + START_TIME + EST
        final_date    = page.at_css('.final-date').text + FINAL_TIME + EST
        course = provider.courses.create!(course_url:    course_url,
                                          name:          name,
                                          code:          code,
                                          instructor:    instructor,
                                          description:   description,
                                          image_link:    image_link,
                                          prerequisites: prerequisites,
                                          start_date:    start_date,
                                          final_date:    final_date)
        add_university!(university)
        @university.teach!(course)
  puts "FINISH" + "*"*10 + name
      end
    end        
  end
puts "*"*5 + "edX OK" + "*"*5   
end

###########################
# Fetch Coursera data
###########################
def fetch_from_coursera
puts "*"*5 + "Coursera" + "*"*5   
  provider = Provider.find_by_name("Coursera")
  browser = Watir::Browser.new :chrome
  url = "https://www.coursera.org"
  courses_path = "/courses"
  courses_url = url + courses_path
puts "open #{courses_url}"    
  browser.goto courses_url
  sleep(20)
  courses_page = Nokogiri::HTML.parse(browser.html)    
  courses_page.css(".coursera-course-listing-box-wide").each_with_index do |course, index|
    course_path = course.at_css(".coursera-course-listing-name .internal-home")['href']
    university_list = []
    course.css(".coursera-course-listing-university span").each do |university|
      university_list << university.text
    end
puts "#{index+1} => #{course_path}" 
    course_url = url + course_path
    # In case of any TimeoutError, check duplication before scraping.
    c = provider.courses.find_by_course_url(course_url)
    if c.nil? 
      browser.goto course_url
      sleep(20)
      page = Nokogiri::HTML.parse(browser.html)
      name = page.at_css("h1").text
puts "BEGIN" + "*"*10 + name
      # SEMI-TODO: seperate multiple instructors  e.g: https://www.coursera.org/course/gametheory   
      instructor = page.at_css(".instructor-name").text
      description = page.at_css(".span6 p").text
      image = page.at_css(".coursera-course-logo img")
      if image.nil?
        image_link = page.at_css(".coursera-course-logo-no-video img")["src"]
      else
        image_link = image["src"]
      end
      start_date_span = page.at_css('.coursera-course-listing span:nth-child(1)')
      if start_date_span.nil?
        start_date = nil
      else
        begin
          start_date = start_date_span.text + START_TIME + PST
        rescue
          start_date = nil
        end
      end
      # format is like: " \n(10 weeks long)"
      duration_span = page.at_css(".coursera-course-listing span:nth-child(2)")
      if duration_span.nil?
        duration = nil
      else
        duration = duration_span.text[/[0-9\.]+/]
      end
      @course = provider.courses.create!(course_url:  course_url,
                                         name:        name,
                                         instructor:  instructor,
                                         description: description,
                                         image_link:  image_link,
                                         start_date:  start_date,
                                         duration:    duration)     
      university_list.each do |university|      
        add_university!(university)
        @university.teach!(@course)
      end
puts "FINISH" + "*"*10 + name
    end # check duplication
  end
puts "*"*5 + "Coursera OK" + "*"*5  
end



################################################################
# Backup
################################################################


################################
# Fetch Coursera data from file
################################
namespace :db do
  desc "Fill database with Coursera courses"
  task coursera_from_html_file: :environment do
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

######################################
# Fetch Cousera data from Coursetalk
######################################
namespace :db do
  desc "Fill database with Coursera courses"
  task coursera_from_coursetalk: :environment do
    provider = Provider.find_by_name("Coursera")
    url = "http://coursetalk.org"
    coursera_path = "/coursera"
    doc = Nokogiri::HTML(open(url + coursera_path))
    doc.css(".course_list td:nth-child(2) a:nth-child(1)").each do |course|
      course_page_url = url + course['href']
      page = Nokogiri::HTML(open(course_url))
      course_name_element = page.at_css("h2 a")
      name = course_name_element.text
      # format is like: "/redirect/110/https://www.coursera.org/course/design"
      course_url = "https:" + course_name_element['href'].split(":")
      university = page.at_css("h5 a").text
      instructor = page.at_css(".course_box strong").text
      #description = 
      #image_link = 
      provider.courses.create!(course_url: course_url,
                               name: name,
                               university: university,
                               instructor: instructor)
    end
  end
end


private
  def add_university!(name)
    university = University.find_by_name(name)
    if university.nil?
      @university = University.create!(name: name)
    else
      @university = university
    end
  end
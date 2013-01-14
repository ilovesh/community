# coding: utf-8

### NOTE: 1 TODO; 1 SEMI-TODO ###
# TODO: unknown characters in below courses' prerequisites:
# Udacity: "Artificial Intelligence for Robotics"
# edX:     "Artificial Intelligence"
# some descriptions/instructors, etc

namespace :db do
  desc "Fetch source data"
  task fetch: :environment do
    Rails.env = 'development'
    require 'nokogiri'
    require 'open-uri'
    require 'watir-webdriver'
                          start1 = Time.now
    #create_providers
                          puts "Providers: #{(Time.now - start1)}" + " seconds"
                          start2 = Time.now
    fetch_from_udacity
                          puts "Udacity: #{(Time.now - start2)/60}" + " minutes"
                          start3 = Time.now    
    fetch_from_edx
                          puts "edX: #{(Time.now - start3)/60}" + " minutes"
                          start4 = Time.now
    #fetch_from_coursera
                          puts "Coursera: #{(Time.now - start3)/60}" + " minutes"    
  end
end

def create_providers
  Provider.create!(name: "Udacity",  website: "http://www.udacity.com")
  Provider.create!(name: "Coursera", website: "http://www.coursera.org")
  Provider.create!(name: "edX",      website: "http://www.edx.org")
end

###########################
# Fetch Udacity data
###########################
def fetch_from_udacity
                                                                                      puts "*"*5 + "Udacity" + "*"*5
  provider = Provider.find_by_name("Udacity")
  website = "http://www.udacity.com"
  doc = Nokogiri::HTML(open(website))
  doc.css(".crs-lst > a").each_with_index do |link, index|
    url = website + link['href']
    c = provider.courses.find_by_url(url) # In case of any TimeoutError, check duplication before scraping.
    if c.nil?
      # SEMI-TODO: below is a temporary solution
      #            cannot find '.overviewButtons p' via Nokogiri in the course page
      coming_soon_span = link.at_css('.crs-coming-soon')
      start_date       = Date.parse("Dec 31 2013 00:00:00 PST") if coming_soon_span
      duration         = start_date.nil? ? 0 : 99 # 99 = upcoming course; 0 = rolling

      page      = Nokogiri::HTML(open(url))
      name_span = page.at_css("h1")
      name      = name_span.text.split('(')[0].strip if name_span
                                                                                      puts "*"*5 + "#{index+1}: " + name        
      
      code_span          = page.at_css('h1 span')
      instructor_span    = page.css(".course-overview-instructor-name")
      description_span   = page.at_css('.course-overview-description-body p')
      image_span         = page.at_css('img.course-icon')
      prerequisites_span = page.at_css('.course-overview-give p') # TODO: unknown character in "Artificial Intelligence for Robotics"
      subtitle_span      = page.at_css('.course-icon-desc-container h2')

      code          = code_span.text.strip if code_span
      description   = description_span.text.strip if description_span
      image_link    = image_span['src'] if image_span
      subtitle      = subtitle_span.text.strip if subtitle_span
      instructor    = fetch_instructor_list(instructor_span)

      unless prerequisites_span.nil?
        prerequisites_span.search('b').remove # remove the extra paragraph like "http://www.udacity.com/overview/Course/cs348/CourseRev/1"
        prerequisites = prerequisites_span.text.strip 
      end

      provider.courses.create!(url:           url,
                               name:          name,
                               code:          code.upcase,
                               instructor:    instructor,
                               description:   description,
                               image_link:    image_link,
                               subtitle:      subtitle,
                               prerequisites: prerequisites,
                               start_date:    start_date,
                               duration:      duration)
                                                                                      puts "FINISH"      
    end # check duplication
  end # each course in the list 
                                                                                      puts "*"*5 + "Udacity OK" + "*"*5 
end

###########################
# Fetch edX data
###########################
def fetch_from_edx
                                                                                      puts "*"*5 + "edX" + "*"*5  
  provider = Provider.find_by_name("edX")
  website = "https://www.edx.org"
  courses_path = "/courses"
  courses_url = website + courses_path
  doc = Nokogiri::HTML(open(courses_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
  doc.css(".courses-listing-item").each_with_index do |course, index|
      url    = website + course.at_css("a")['href']
      name_span = course.at_css(".course-preview h2")
      name      = name_span.text.strip.split("x ")[1] if name_span
      description_span = course.at_css(".desc p")
      description      = description_span.text.strip if description_span
                                                                                      puts "*"*5 + "#{index+1}: " + name
      
      c = provider.courses.find_by_url(url) # In case of any TimeoutError, check duplication before scraping.
      if c.nil?
        page               = Nokogiri::HTML(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))      
        code_span          = page.at_css("span.course-number")
        university_span    = page.at_css(".intro h1 a")
        instructor_span    = page.css(".teacher h3")
        image_span         = page.at_css(".hero img")
        prerequisites_side_span = page.at_css(".prerequisites .start-date")
        prerequisites_span = page.css(".Prerequisites p")
        prerequisites_span = page.at_css(".inner-wrapper .prerequisites p") if prerequisites_span.blank?
        start_date_span    = page.at_css('.start-date')
        final_date_span    = page.at_css('.final-date')

        code          = code_span.text.strip if code_span
        university    = university_span.text.strip if university_span
        image_link    = website + image_span["src"] if image_span
        instructor    = fetch_instructor_list(instructor_span)

        prerequisites_side = prerequisites_side_span.text.strip if prerequisites_side_span
        unless prerequisites_span.nil?
          if prerequisites_span.is_a?(Array)
            prerequisites_list = []
            prerequisites_span.each {|pre| prerequisites_list << pre}
            prerequisites = prerequisites_list.join("|")
          else
            prerequisites = prerequisites_span.text.strip
          end
        end
        prerequisites = prerequisites_side if prerequisites.nil? && prerequisites_side != "None"

        unless start_date_span.nil?
          begin
            start_date = start_date_span.text.strip + START_TIME + EST
          rescue
            start_date = Date.parse("Dec 31 2013 00:00:00 EST")
            duration = 99
          end
        end
        
        unless final_date_span.nil?
          begin
            final_date = final_date_span.text.strip + FINAL_TIME + EST
          rescue
            final_date = Date.parse("Jan 1 2014 00:00:00 EST")
          end
        end

        c = provider.courses.find_by_code(code)
        if c
          c.multi = true
          c.save
          c.sessions.create!(start_date: start_date,
                             final_date: final_date,
                             duration:   duration,
                             url:        url)          
        else
          course = provider.courses.create!(url:           url,
                                            name:          name,
                                            code:          code,
                                            instructor:    instructor,
                                            description:   description,
                                            image_link:    image_link,
                                            prerequisites: prerequisites,
                                            start_date:    start_date,
                                            final_date:    final_date,
                                            duration:      duration)
          add_university_and_teaching!(university, course)
        end # check multi sessions 
                                                                                      puts "FINISH"
      end # check duplication
  end # each course
                                                                                      puts "*"*5 + "edX OK" + "*"*5   
end

###########################
# Fetch Coursera data
###########################
def fetch_from_coursera
                                                                                      puts "*"*5 + "Coursera" + "*"*5   
  provider = Provider.find_by_name("Coursera")
  browser = Watir::Browser.new :chrome
  website = "https://www.coursera.org"
  courses_path = "/courses"
  courses_url = website + courses_path   
  browser.goto courses_url
  sleep(20)
  courses_page = Nokogiri::HTML.parse(browser.html)    
  courses_page.css(".coursera-course-listing-box-wide").each_with_index do |course, index|
    course_path_span = course.at_css(".coursera-course-listing-name .internal-home")
    course_path      = course_path_span['href'] if course_path_span
    url = website + course_path
    university_list = []
    course.css(".coursera-course-listing-university span").each { |university| university_list << university.text.strip }
    c = provider.courses.find_by_url(url) # In case of any TimeoutError, check duplication before scraping.
    if c.nil?
      browser.goto url
      sleep(5)
      page      = Nokogiri::HTML.parse(browser.html)
      name_span = page.at_css("h1")
      name      = name_span.text.strip if name_span
                                                                                      puts "*"*5 + "#{index+1}: " + name
      instructor_span  = page.at_css(".instructor-name")
      description_span = page.at_css(".span6 p")
      image_span       = page.at_css(".coursera-course-logo img")
      image_span       = page.at_css(".coursera-course-logo-no-video img") if image_span.nil?
      start_date_span  = page.css('.coursera-course-listing span:nth-child(1)')
      duration_span    = page.css(".coursera-course-listing span:nth-child(2)")
      start_date_span  = page.at_css(".coursera-course-listing:nth-child(2) span:nth-child(1)") if start_date_span.nil?
      instructor_span.search('br').each {|br| br.replace("|")}
      instructor  = instructor_span.text.strip if instructor_span
      description = description_span.text.strip if description_span
      image_link  = image_span["src"] if image_span    

      unless start_date_span.nil?
        if start_date_span.count > 1
          sd1 = start_date_span[0]
          sd2 = start_date_span[1]
          d1 = duration_span[0] if duration_span
          d2 = duration_span[1] if duration_span
        else
          sd1 = start_date_span
          d1 = duration_span if duration_span
        end
        start_date_span_text = sd1.text.strip
        start_date = nil
        if start_date_span_text == "Self study"
          duration = 0
        elsif start_date_span_text == "Date to be announced"
          duration = 99
        else
          begin
            start_date = start_date_span_text + START_TIME + PST
          rescue
            start_date = nil
          end
          duration    = d1.text[/[0-9\.]+/].strip if d1.text[/[0-9\.]+/] # format is like: " \n(10 weeks long)"
        end
      end

      course = provider.courses.create!(url:         url,
                                        name:        name,
                                        instructor:  instructor,
                                        description: description,
                                        image_link:  image_link,
                                        start_date:  start_date,
                                        duration:    duration)

      university_list.each {|university| add_university_and_teaching!(university, course)}
      
      if sd2
        course.multi = true
        course.save
        start_date_span_text = sd2.text.strip
        start_date = nil
        if start_date_span_text == "Self study"
          duration = 0
        elsif start_date_span_text == "Date to be announced"
          duration = 99
        else
          begin
            start_date = start_date_span_text + START_TIME + PST
          rescue
            start_date = nil
          end
          duration = d2.text[/[0-9\.]+/].strip if d2.text[/[0-9\.]+/]
        end
        course.sessions.create!(start_date: start_date,
                                duration: duration,
                                url: url)
      end
                                                                                      puts "FINISH"
    end # check duplication
  end # each course in the list
                                                                                      puts "*"*5 + "Coursera OK" + "*"*5  
end

private
  def fetch_instructor_list(instructor_span)
    unless instructor_span.nil?
      instructor_list = []
      instructor_span.each { |instructor_column| instructor_list << instructor_column.text.strip }
      instructor = instructor_list.join("|")
    end
  end

  def add_university!(name)
    university = University.find_by_name(name)
    if university.nil?
      university = University.create!(name: name)
    else
      university = university
    end
  end

  def add_university_and_teaching!(university_name, course)
    university = add_university!(university_name)
    university.teach!(course)
  end


################################
# BACKUP: Fetch Coursera data from file
################################
def fetch_coursera_from_html_file
  provider = Provider.find(2)
  url = "https://www.coursera.org"
  # Read data from a local html file => file located in "project root/db/"
  doc = Nokogiri::HTML(File.open(Rails.root.join "db/coursera.html"))
  doc.css(".coursera-course-listing-box").each do |course|
    #TODO  
  end
end
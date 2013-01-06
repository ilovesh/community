namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #make_providers
    #make_universities
    #make_courses
    #make_users
    #make_enrollments
    make_discussions
    make_lists
    #make_comments
    #make_notes
    #make_reviews
  end
end


def make_users
  user = User.create!(username: "Example User",
                      email:    "example@gmail.com",
                      password: "foobar")
  99.times do |n|
    username  = Faker::Internet.user_name + n.to_s
    email     = "example-#{n+1}@gmail.com"
    password  = "password"
    User.create!(username: username,
                 email:    email,
                 password: password)
  end
end

def make_providers
  #Provider.create!(name: "SEE",        website: "see.stanford.edu")
  Provider.create!(name: "Codecademy",     website: "www.codecademy.com")  
  Provider.create!(name: "KhanAcademy",    website: "www.khanacademy.org")
  Provider.create!(name: "Udacity",        website: "www.udacity.com")
  Provider.create!(name: "Coursera",       website: "www.coursera.org")
  Provider.create!(name: "edX",            website: "www.edx.org")
  Provider.create!(name: "Canvas Network", website: "www.canvas.net")
  Provider.create!(name: "openHPI",        website: "openhpi.de")
  Provider.create!(name: "MRUniversity",   website: "mruniversity.com")
  Provider.create!(name: "Class2Go",       website: "class.stanford.edu")
  Provider.create!(name: "Venture Lab",    website: "venture-lab.org")
  Provider.create!(name: "OpenLearning",   website: "www.openlearning.com")
  Provider.create!(name: "10gen",          website: "education.10gen.com") 
end

def make_universities
  10.times do
    University.create!(name: Faker::Education.school)
  end
end

def make_courses
  providers = Provider.all
  providers.each do |provider|
    15.times do |n|
      name          = Faker::Education.major
      code          = 100 + n
      image_link    = "lorempixel.com/120/120/"
      description   = Faker::Lorem.paragraph
      subtitle      = Faker::Lorem.words(3).join(' ')
      instructor    = Faker::Name.name
      prerequisites = Faker::Lorem.sentence
      course_url    = "https://www.coursera.org/course/compfinance"
      dates         = ["Nov 1, 2012", "Feb 10, 2013"]
      start_date    = Date.parse(dates.sample)
      duration      = [0, 99, 5, 15].sample
      course      = provider.courses.create!(name:          name,
                                             code:          code,
                                             image_link:    image_link,
                                             description:   description,
                                             subtitle:      subtitle,
                                             instructor:    instructor,
                                             prerequisites: prerequisites,
                                             course_url:    course_url,
                                             start_date:    start_date,
                                             duration:      duration)
      University.all.sample.teach!(course)
    end
  end
end


def make_enrollments
  users = User.all
  users.each do |user|
    status = 1 + SecureRandom.random_number(3)
    tag_list = "#{Faker::Lorem.word},#{Faker::Lorem.word},#{Faker::Lorem.word}"
    enrollment = user.enroll!(Course.all.sample, status, tag_list)
  end
end

def make_discussions
  users = User.all(limit: 6)
  users.each do |user|
    10.times do 
      title = Faker::Lorem.sentence
      content = Faker::Lorem.paragraph
      discussion = user.discussions.create!(title: title, content: content)
      discussion.tag_list = "#{Faker::Lorem.word},#{Faker::Lorem.word},#{Faker::Lorem.word}"
      discussion.save
    end
  end
end

def make_lists
  users = User.all(limit: 6)
  users.each do |user|
    7.times do 
      #user = User.all.sample
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph
      list = user.lists.create!(title: title, description: description)
      list.tag_list = "#{Faker::Lorem.word},#{Faker::Lorem.word},#{Faker::Lorem.word}"
      list.save
      5.times do |n|
        course = Course.all.sample
        description = Faker::Lorem.sentence
        list.listings.create!(course_id: course.id, description: description)
      end
    end
  end
end

def make_comments
  discussions = Discussion.all(limit: 50)
  discussions.each do |discussion|
    5.times do
      comment = User.all.sample.comment!(discussion, Faker::Lorem.sentence)
      comment.save
    end
  end
  lists = List.all(limit: 50)
  lists.each do |list|
    5.times do
      comment = User.all.sample.comment!(list, Faker::Lorem.sentence)
      comment.save
    end
  end
end

def make_notes
  courses = Course.all(limit: 10)
  courses.each do |course|
    20.times do
      User.all.sample.take_note!(course, Faker::Lorem.paragraph+Faker::Lorem.paragraph)
      User.all.sample.take_note!(course, Faker::Lorem.paragraph+Faker::Lorem.paragraph, Faker::Lorem.sentence)
    end
  end
end

def make_reviews
  courses = Course.all(limit: 10)
  courses.each do |course|
    20.times do
      User.all.sample.review!(course, Faker::Lorem.paragraph)
      User.all.sample.review!(course, Faker::Lorem.paragraph+Faker::Lorem.paragraph, Faker::Lorem.sentence)
    end
  end
end
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_providers
    make_courses
    make_enrollments
    make_discussions
    make_lists
    make_comments
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
  #Provider.create!(name: "Codecademy",     website: "www.codecademy.com")  
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

def make_courses
  providers = Provider.all
  providers.each do |provider|
    15.times do |n|
      name        = Faker::Education.major
      progress    = 1 + SecureRandom.random_number(3)
      code        = 100 + n
      image_link  = "lorempixel.com/120/120/"
      description = Faker::Lorem.paragraph
      course      = provider.courses.create!(name:        name,
                                             progress:    progress,
                                             code:        code,
                                             image_link:  image_link,
                                             description: description)
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
  50.times do
    title = Faker::Lorem.sentence
    content = Faker::Lorem.paragraph
    users.each do |user|
      discussion = user.discussions.create!(title: title, content: content)
    end
  end
end

def make_lists
  users = User.all(limit: 6)
  5.times do
    users.each do |user|
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph
      list = user.lists.create!(title: title, description: description)
      5.times do |n|
        course = Course.find(n+2)
        description = Faker::Lorem.sentence
        list.listings.create!(course_id: course.id, description: description)
      end
    end
  end
end

def make_comments
  courses = Course.all
  courses.each do |course|
    5.times do
      comment = User.all.sample.comment!(course, Faker::Lorem.sentence)
      comment.save
    end
  end
  discussions = Discussion.all
  discussions.each do |discussion|
    5.times do
      comment = User.all.sample.comment!(discussion, Faker::Lorem.sentence)
      comment.save
    end
  end
  lists = List.all
  lists.each do |list|
    5.times do
      comment = User.all.sample.comment!(list, Faker::Lorem.sentence)
      comment.save
    end
  end
end
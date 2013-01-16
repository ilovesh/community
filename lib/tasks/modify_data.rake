# coding: utf-8

namespace :db do
  desc "Modify source data"
  task modify: :environment do
    Rails.env = 'development'
    
    c = Course.find_by_url("http://www.udacity.com/overview/Course/cs373")
    c.prerequisites = "You should either already know Python, or have enough experience with another language to be confident you can pick up what you need on your own.Fortunately, Python was built to be easy to learn, read, and use. If you already know another programming language, you'll be coding in Python in less than an hour. Additionally, knowledge of probability and linear algebra will be helpful."
    c.save

    c = Course.find_by_url("http://www.udacity.com/overview/Course/cs222")
    c.instructor = "Jörn Loviscach|Miriam Swords Kalk"
    c.save

    c = Course.find_by_url("http://www.udacity.com/overview/Course/cs291")
    c.prerequisites = "Knowing how to program in some language is all you'll need to get started. Some knowledge of JavaScript is useful later on if you wish to make your projects more interactive and engaging. Familiarity with vectors and matrices will ease your way but is not critical."
    c.save

    c = Course.find_by_code("CS188.1x")
    c.description = "CS188.1x is a new online adaptation of the first half of UC Berkeley's CS188: Introduction to Artificial Intelligence. The on-campus version of this upper division computer science course draws about 600 Berkeley students each year."
    c.save

    # Course 149, 150, 151
    # add start_date Jan.30, duration 50

  end
end
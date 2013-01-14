# coding: utf-8

namespace :db do
  desc "Write blogs"
  task blog: :environment do
    
    # 130115
    body = "Hi There! Welcome to Courigin!\n"\
           "A few months ago, I started to learn to program out of curiosity."\
           "I feel amazed at <%= link_to 'these courses', List.find(1) %> I've taken, and it's really fun to "\
           "learn things together. So I build Courigin to collect the great resources "\
           "and I hope we learn and share together!\n"\
           "Currently I've added courses from Cousera, edX and Udacity, and I'm keeping to add other resources. "\
           "If you have any suggestion or encounter any bug, "\
           "please post a comment <%= link_to 'here', Discussion.find(1) %> or "\
           "<%= link_to 'send me an email', 'mailto:contact@courigin.com' %>"
           "Let's improve Courigin together!\n"\
           "Cheers,"

    Blog.new(body: body).save

  end
end
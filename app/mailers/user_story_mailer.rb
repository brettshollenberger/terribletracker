class UserStoryMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "heroku.com"

  def assignment_mailer(user, story)
    @base_url = "http://terribletracker-staging.herokuapp.com"
    @user = user
    @story = story
    @team = @story.project.team
    @url = "#{@base_url}/user_story/#{@story.id}"
    mail(:to => "#{@user.email}", :subject => "You've been assigned to #{@story.title} on Terrible Tracker")
  end

end

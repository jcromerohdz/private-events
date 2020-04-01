# Microverse Project Title - Associations [Collaborative Project]
Ruby on Rails

## Screenshot

![](https://github.com/jcromerohdz/private-events/blob/development/image/screenshot.JPG)

### Introduction.
In this project, you will build an application named Private Events and that behaves similar to Eventbrite. The main goal is to put in practice the main concepts of Associations in rails.

Full task description: https://www.theodinproject.com/courses/ruby-on-rails/lessons/associations.

### Microverse Adjustments

You should do the “Project 1: Ruby on Rails Tutorial” individually, and then you will complete the project Private Events together with your partner. Once you are finished with this project, continue working together with your coding partner on the next project. You must still remain in a video call with your partner during your independent work.

Please submit only “Project 2: Private Events”.

### Project specific

Make sure that all foreign keys have corresponding indexes in Database, as it will make your database performance better.
Remember about tests in your code
Refresher: Test Driven Development
Add unit tests for models associations and validations (use Rspec hint)
Add integrations tests for authentication and events managment (use Rspec and Capybara hint)
Hint: Setting up Rspec and Capybara

###  Ruby version

rbenv 2.6.5

###  System dependencies

Rails 6.0.1

Yarn 1.19.1

Ubuntu 18.04 & below

###  Database creation

sqlite3

###  Database initialization

###  Services (job queues, cache servers, search engines, etc.)

###  Deployment instructions

1. Open the terminal.

2. Enter git clone https://github.com/jcromerohdz/private-events.git

3. Navigate to the cloned repository.

4. Migrate database with this command "rails db:migrate"

5. Populate user database with this command "rails db:seed" populate user and event database

6. Run "bundle install" command to install all relevant gems

7. Run "rails server" command and open browser using "localhost:3000"

8. Sign in with default login (email: batman@email.com)

## Command to kill Puma webserver on Ubuntu

# List processes
ps ax

then 
 
kill -9 <pid>

## To purge and reseed database

rake db:drop
rake db:create
rake db:schema:load
rake db:seed 

and then run:

rake db:migrate
rake db:test:prepare
rake db:prepare

0. Gemfile Setup

gem 'bootstrap_form', '~> 4.3'
gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'faker',          '1.7.3'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'
gem 'rails-controller-testing'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
```

0.1 Setup main page
```sh
$ rails generate controller StaticPages home about
.
.
.
```

```ruby
# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  def home
    if current_user
      @user = current_user
      @user_events = @user.events
      @upcoming_events = @user.attended_events.upcoming
      @past_events = @user.attended_events.past
    end
  end

  def about
  end
end
```

```erb
# app/views/static_pages/home.html.erb

<% provide(:title, 'Home') %>
<section class="first-section">
  <h1 class="centered-text">Welcome to the Eventblitz</h1>
  <div class="welcome-container">
    <% if signed_in? %>
      <div class="buttonme">
        <a class="btn btn-lg btn-success" href="/events/new" role="button">Create an event</a>
      </div>
      <h3>
        Hi there <%= @user.name %>,
        <% if @upcoming_events.count > 0 || @user_events.any? %>
          you have <%= @upcoming_events.count %> event(s) to attend.</h3>
          <h4>Upcoming Event(s):</h4>
          <div class="attending-events-container">
            <%= render partial: "events/event", object: @upcoming_events, as: 'events' %>
          </div>
          <h4>Event(s) created by you:</h4>
            <div class="attending-events-container">
              <%= render partial: "events/event", object: @user.events, as: 'events' %>
          </div>
        <% else %>
        <h3>you don't have any future events to attend to.</h3>
        <% end %>
    <% else %>
      <div class="jumbotron">
        <h1>Plan an Event</h1>
        <p class="lead">Keep track of events with your friends.  This is a simple app to organize your event planning.
           </p>
        <a class="btn btn-lg btn-success" href="/events/new" role="button">Create an event</a>
      </div>
      <h3>Not a participant yet? <%= link_to "Join us", signup_path %> now!</h3>
    <% end %>
  </div>
</section>

# /app/views/layout/application.html.erb

<!DOCTYPE html>
<html>
  <head>
    <title>Event Blitz App</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <% flash.each do |message_type, message| %>
        <%= content_tag(:div, message, class: "alert alert-#{message_type}") %>
      <% end %>
      <%= yield %>
      <%= render 'layouts/footer' %>
    </div>
  </body>
</html>

# app/views/static_pages/_header.html.erb

<header class="navbar navbar-fixed-top navbar-inverse">
	<div class="container">
	  <%= link_to "Eventblitz app", root_path, id: "logo" %>
	  <nav>
	    <ul class="nav navbar-nav navbar-right">
	      <li><%= link_to "Home",   root_path %></li>
	      <li><%= link_to "Users",   users_path %></li>
	      <li><%= link_to "Event",   events_path  %></li>
	      <li><%= link_to "About",   about_path %></li>
	      <% if signed_in? %>
	        <li><%= link_to "#{current_user.name} (Log Out)", signout_path, method: "delete" %></li>
	      <% else %>
	        <li><%= link_to "Log In", signin_path %></li>
	      <% end %>
	    </ul>
	  </nav>
	</div>
</header>

# app/views/static_pages/footer.html.erb

<footer class="footer">
  <small>
  	An Event Planner Webapp by <a href="https://github.com/jcromerohdz">Christian Romera</a> and <a href="https://github.com/geraldgsh">Gerald Goh</a>
  </small>
</footer>
``` 

```ruby
# /config/routes.rb

PrivateEvents::Application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get    '/about',   to: 'static_pages#about'
.
.
.
```

0.2 Setup tester for main page
```sh
# test/controllers/static_pages_controller_test.rb

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_response :success
  end
end

/app/main_page/views/home.html.erb

<% provide(:title, "Home") %>

/app/views/main_page/about.html.erb

<% provide(:title, "About") %>

/app/views/layout/application.html.erb

<head>
    <title><%= full_title(yield(:title)) %></title>
.
.
.
```

0.3 Helper for main pages
```sh
app/helpers/application_helper.rb

module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Event Planning App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
```

0.4 Bootstrap
```sh
@import "bootstrap-sprockets";
@import "bootstrap";

/* mixins, variables, etc. */

$light-gray: #777;
$gray-medium-light: #eaeaea;

@mixin box_sizing {
  -moz-box-sizing:    border-box;
  -webkit-box-sizing: border-box;
  box-sizing:         border-box;
}

/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: #fff;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
  &:hover {
    color: #fff;
    text-decoration: none;
  }
}

/* Main message and sign up button */
.jumbotron {
  text-align: center;
  border-bottom: 1px solid #e5e5e5;
  .btn {
    padding: 14px 24px;
    font-size: 21px;
  }
}

.buttonme {
  text-align: center;
  border-bottom: 1px;
  .btn {
    padding: 14px 24px;
    font-size: 21px;
  }
}

/* typography */

h1, h2, h3, h4, h5, h6 {
  line-height: 1;
}

h1 {
  font-size: 3em;
  letter-spacing: -2px;
  margin-bottom: 30px;
  text-align: center;
}

h2 {
  font-size: 1.2em;
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: $light-gray;
}

h3 {
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: Black;
}

h4 {
  color: Black;
  font-weight: bold;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}

/* universal */

body {
  padding-top: 60px;
}

section {
  overflow: auto;
}

textarea {
  resize: vertical;
}

.center {
  text-align: center;
  h1 {
    margin-bottom: 10px;
  }
}

/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid $gray-medium-light;
  color: $light-gray;
  a {
    color: $gray;
    &:hover {
      color: $gray-darker;
    }
  }
  small {
    float: left;
  }
  ul {
    float: right;
    list-style: none;
    li {
      float: left;
      margin-left: 15px;
    }
  }
}

.users {
  list-style: none;
  margin: 0;
  padding-left: 0;
  li {
    overflow: auto;
    text-align: center;
    padding: 10px 0;
    border-top: 1px solid #e8e8e8;
    &:last-child {
      border-bottom: 1px solid #e8e8e8;
    }
  }
}

/* forms */

input, textarea, select, .uneditable-input {
  border: 1px solid #bbb;
  width: 100%;
  margin-bottom: 15px;
  @include box_sizing;
}

input {
  height: auto !important;
}

#error_explanation {
  color: red;
  ul {
    color: red;
    margin: 0 0 30px 0;
  }
}

.field_with_errors {
  @extend .has-error;
  .form-control {
    color: $state-danger-text;
  }
}

.checkbox {
  margin-top: -10px;
  margin-bottom: 10px;
  span {
    margin-left: 20px;
    font-weight: normal;
  }
}
```

0.5 Flash error message setup for login page
```erb
app/views/layouts/application.html.erb
.
.
<div class="container">
  <% flash.each do |message_type, message| %>
    <%= content_tag(:div, message, class: "alert alert-#{message_type}") %>
  <% end %>
.
.

app/controller/session.html.erb

def create
.
.
    else
      flash.now[:danger] = 'Invalid email'
      render 'new'
.
.

```

0.6 Rspec test Setup

Ensure rspec-rails present in both the :development and :test groups of your app’s Gemfile:
```sh
# Run against the latest stable release
group :development, :test do
  gem 'rspec-rails', '~> 4.0'
end

```

Then, in your project directory:
```sh
# Download and install
$ bundle update
$ bundle install
$ bundle update rspec-rails

# Generate boilerplate configuration files
# (check the comments in each generated file for more information)
$ rails generate rspec:install
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb
```

# spec/models/user_spec.rb
```sh
require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    User.create(name: 'test', email: 'test@test.com')
  end
  describe '#name' do
    before :each do
      User.create(name: 'test', email: 'test@test.com')
    end
    it 'doesnt take user without the name' do
      user = User.new
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")

      user.name = 'test'
      user.valid?
      expect(user.errors[:name]).to_not include("can't be blank")
    end    
  end

  describe '#email' do
    it 'validates for presence of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = ''
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end

    it 'validates for format of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = 'test@test..com'
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end
  end

  describe '#attended_events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.last.attended_events.first).to eql(event)
    end
  end

  describe '#events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2020-08-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.find_by_email('creator@email.com').events.first).to eql(event)
    end
  end
end
```
# spec/models/event_spec.rb
```ruby

```


Create boilerplate specs with rails generate after coding is complete
```sh
# RSpec also provides its own spec file generators
$ rails generate rspec:model user
      create  spec/models/user_spec.rb

# List all RSpec generators
$ rails generate --help | grep rspec

Running specs
# Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)
$ bundle exec rspec

# Run all spec files in a single directory (recursively)
$ bundle exec rspec spec/models

# Run a single spec file
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb

# Run a single example from a spec file (by line number)
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb:8

# See all options for running specs
$ bundle exec rspec --help
```

# Authentication Feature RSPEC Test
```ruby
# spec/features/authentication_spec.rb
require 'rails_helper'

RSpec.feature "Authentications", type: :feature do
  before :each do
    @user = User.create(name: 'creator', email: 'test@test.com')
  end

  it 'Sign In' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
  end
  
  it 'Sign Out' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    click_on 'Log Out'
    expect(page).to have_content 'Welcome to Eventblitz'
  end

end
```

# Event_management Feature RSPEC Test
```ruby
require 'rails_helper'

RSpec.feature "EventsManagements", type: :feature do
  before :each do
    @user = User.create(name: 'creator', email: 'test@test.com')
  end

  it 'Event Creation' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in "event[name]", with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
  end

  it 'Attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in "event[name]", with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link "Attend to event"
    page.find('ol', text: 'creator')
  end

  it 'Attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in "event[name]", with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link "Attend to event"
    page.find('ol', text: 'creator')
  end

  it 'Not attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in "event[name]", with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link "Attend to event"
    page.find('ol', text: 'creator')
    click_link "Not going anymore"
    expect(page).to have_content "No attendees for this event yet"
  end

end
```

# User model RSPEC test
```ruby
# spec/models/user_spec

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    User.create(name: 'test', email: 'test@test.com')
  end
  describe '#name' do
    before :each do
      User.create(name: 'test', email: 'test@test.com')
    end
    it 'doesnt take user without the name' do
      user = User.new
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")

      user.name = 'test'
      user.valid?
      expect(user.errors[:name]).to_not include("can't be blank")
    end    
  end

  describe '#email' do
    it 'validates for presence of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = ''
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end

    it 'validates for format of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = 'test@test..com'
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end
  end

  describe '#attended_events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.last.attended_events.first).to eql(event)
    end
  end

  describe '#events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2020-08-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.find_by_email('creator@email.com').events.first).to eql(event)
    end
  end
end

```

# Event Model RSPEC test
```ruby
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'All credetial are provide' do
    it 'should have creator' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = user.events.build(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: user.id)
      event.valid?
      expect(event).to be_valid  
    end
  end

  describe 'no date provided' do
    it 'is not valid ' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: 'texas', description: 'event description', time: nil, creator_id: user.id)
      expect(event.valid?).to be false
    end
  end

  describe 'no creator id provided' do
    it 'is not valid' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: nil)
      expect(event.valid?).to be false
    end
  end

  context 'no description provided' do
    it 'is not valid' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: nil , description: 'event description', time: '2019-12-26', creator_id: user.id)
      expect(event.valid?).to be false
    end
  end
end
```

### Setup and Sign In

1. Model the data for your application, including the necessary tables.
```sh
# User
a. Name
b. Email

# Event (sign up)
a. Title
b. Location
c. Description
d. Date
e. Foreign Key - User ID #Association many-to-many
f. attend

# Attendance
a. Location
b. Host - event creator
c. who's going - attendance (can cancel)
d. foreign key - users who signed up

# Invites
a. Users can be invite to an event

```

2. Create a new Rails application and Git repo called private-events.
```sh
$  rails new private-events
```

3. Update your README to be descriptive and link to this project.
```sh
Done!
```

4. Build and migrate your User model. Don’t worry about validations. But we worry about validations so we added! 
```sh
$ rails generate model User name:string email:string
Running via Spring preloader in process 32582
      invoke  active_record
      create    db/migrate/20191125200116_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml

$ rails db:migrate
== 20191125200116 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0016s
== 20191125200116 CreateUsers: migrated (0.0019s) =============================

```

## User validations

```ruby
test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end

# app/models/user.rb
class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
end
```
## Validation for unique signup

```sh
$ rails generate migration add_index_to_users_email
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
Running via Spring preloader in process 577
      invoke  active_record
      create    db/migrate/20191124024753_add_index_to_users_email.rb
```

```ruby
db/migrate/[date]_add_index_to_users_email.rb
class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email, unique: true
  end
end
```

```sh
rails db:migrate
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
== 20191124024753 AddIndexToUsersEmail: migrating =============================
-- add_index(:users, :email, {:unique=>true})
   -> 0.0032s
== 20191124024753 AddIndexToUsersEmail: migrated (0.0038s) ====================
```
```sh
test/fixtures/users.yml
one:
  name: MyString
  location: MyString
  description: MyText
  time: 2019-11-27 01:15:38

two:
  name: MyString
  location: MyString
  description: MyText
  time: 2019-11-27 01:15:38
```

## Seeding Database with users

```ruby
# app/db/seeds.rb
User.create!(name:  "Batman",
             email: "batman@email.com")

199.times do |n|
  name  = Faker::Name.name
  email = "batman-#{n+1}@email.com"
  User.create!(name:  name,
               email: email)
end
```


5. Create a simple Users controller and corresponding routes for #new, #create, and #show actions. You’ll need to make a form where you can sign up a new user and a simple #show page. You should be getting better and faster at this type of vanilla controller/form/view building.
```sh
$ rails generate controller Users
Running via Spring preloader in process 990
      create  app/controllers/users_controller.rb
      invoke  erb
      create    app/views/users
      invoke  test_unit
      create    test/controllers/users_controller_test.rb
      invoke  helper
      create    app/helpers/users_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/users.scss

```

```ruby
# app/controllers/user_controllers.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    if signed_in?
      @user = User.find_by(id: session[:user_id])
      @user_events = @user.events
      @upcoming_events = @user.attended_events.upcoming
      @past_events = @user.attended_events.past
    else
      redirect_to signin_path
    end
  end

  def going
    @event = Event.find(params[:id])
    @user = current_user
    @user.attended_events << @event
    @user.save
    redirect_to event_path(id: @event.id)
  end

  def not_going
    @event = Event.find(params[:id])
    @user = current_user
    @user.attended_events.delete(@event)
    redirect_to event_path(id: @event.id)
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end

```

```erb
# app/views/users/new.html.erb
<h1>Sign Up</h1>
<%=  bootstrap_form_for @user, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10" do |f| %>
  <%= f.text_field :name %>
  <%= f.text_field :email %>  
  <%= f.form_group do %>
	  <div class="buttonme">
      <%= f.submit "Create my account", class: "btn btn-large btn-primary" %>
	  <% end %>
	</div>
<% end %>
```

# /config/routes.rb

PrivateEvents::Application.routes.draw do
.
.
  resources :users, only: [:new, :create, :show, :index]
  get  '/signup',  to: 'users#new'
.
.
end

6. Create a simple sign in function that doesn’t require a password – just enter the ID or name of the user you’d like to “sign in” as and click Okay. You can then save the ID of the “signed in” user in either the session hash or the cookies hash and retrieve it when necessary. It may be helpful to always display the name of the “signed in” user at the top.

```sh
$ rails generate migration add_remember_token_to_users remember_token:string
Running via Spring preloader in process 5942
      invoke  active_record
      create    db/migrate/20191125211218_add_remember_token_to_users.rb

$ rails generate controller Sessions
Running via Spring preloader in process 4380
      create  app/controllers/sessions_controller.rb
      invoke  erb
      create    app/views/sessions
      invoke  test_unit
      create    test/controllers/sessions_controller_test.rb
      invoke  helper
      create    app/helpers/sessions_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/sessions.scss

```

```ruby
#/db/migrate/20191125211218_add_remember_token_to_users.rb
class AddRememberTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end
```

```sh
$ rails db:migrate
== 20191125211218 AddRememberTokenToUsers: migrating ==========================
-- add_column(:users, :remember_token, :string)
   -> 0.0015s
-- add_index(:users, :remember_token)
   -> 0.0010s
== 20191125211218 AddRememberTokenToUsers: migrated (0.0026s) =================

```

```ruby
class SessionsController < ApplicationController
  def new
  end
	
  def create 
    user = User.find_by(email: params[:session][:email])
    if user
      log_in user
      redirect_to user
    else 
      flash.now[:danger] = 'Invalid email'
      render 'new'
    end 
  end 
	
  def destroy  
    log_out
    if logged_in?
      redirect_to root_path
    end
  end
end
```

```erb
# app/views/sessions/new.html.erb

<h1>Sign In</h1>

<%= bootstrap_form_for(:session, url: sessions_path, layout: :horizontal) do |f| %>

  <%= f.text_field :email %>   
  <%= f.form_group do %>
    <%= f.submit "Sign in", class: "btn btn-large btn-primary" %>
  <% end %>

  <%= f.form_group do %>
    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  <% end %>

<% end %>
```

```ruby
# /config/routes.rb

PrivateEvents::Application.routes.draw do
.
.
  resources :sessions, only: [:new, :create, :destroy]
  get    '/signin',   to: 'sessions#new'
  post   '/signin',   to: 'sessions#create'
  delete '/signout',  to: 'sessions#destroy'
.
.
end
```

# Test for login sessions

```ruby
test/controllers/sessions_controller_test.rb
require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signin_path
    assert_response :success
  end
end
```

```sh
It works!
```

### Basic Events

1.Build and migrate your Event model without any foreign keys. Don’t worry about validations. Include the event’s date in your model but don’t worry about doing anything special with it yet.
```sh
$ rails generate model Event name:string location:string description:text date:time

      invoke  active_record
      create    db/migrate/20191126171538_create_events.rb
      create    app/models/event.rb
      invoke    test_unit
      create      test/models/event_test.rb
      create      test/fixtures/events.yml

$ rails db:migrate

== 20191126171538 CreateEvents: migrating =====================================
-- create_table(:events)
   -> 0.0037s
== 20191126171538 CreateEvents: migrated (0.0042s) ============================
```

2. Add the association between the event creator (a User) and the event. Call this user the “creator”. Add the foreign key to the Events model as necessary. You’ll need to specify your association properties carefully (e.g. :foreign_key, :class_name, and :source).
```sh
$ rails generate migration add_creator_to_event
      invoke  active_record
      create    db/migrate/20191125220747_add_creator_to_event.rb
```

```ruby
# /migrate/[timestamp]_add_creator_to_event.rb

class AddCreatorToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :creator_id, :integer
  end
end
```

```ruby
/app/models/event.rb

class Event < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :time, presence: true


  def creator
    User.find_by(id: self.creator_id).name
  end
end
```

3. Modify your User’s Show page to list all the events a user has created.
```erb
/app/views/users/show.html.erb

<h2 class="centered-text">Welcome
  <%= @user.name %></h2>
<% if @user_events.any? %>
  <h3 class="centered-text" >Events created by you:</h3>
  <div class="attending-events-container">
    <%= render partial: "events/event", object: @user.events, as: 'events' %>
  </div>
<% else %>
  <h3 class="centered-text">You didn't create any events yet.</h3>
<% end %>
<%= render partial: 'events/upcoming_past',
           locals: { upcoming: @upcoming_events, past: @past_events } %>
````

```erb
# app/views/events/_event.html.erb

<table class="table table-condensed">   
  <thead>
    <tr>
      <td class="col-sm-2">Date</td>
      <td class="col-sm-4">Name</td>
      <td class="col-sm-3">Location</td>
      <td class="col-sm-2">Host</td>
      <td class="col-sm-1">Attend</td>
    </tr>
  </thead>

  <% events.each do |event| %>
  <tr>
    <td><%= event.time.strftime("%d/%m/%Y")  %></td>
    <td><%= link_to event.name, event_path(event) %></td>
    <td><%= event.location %></td>
    <td><%= link_to event.creator, user_path(event.creator) %></td>
    <td class="text-center"><%= event.attendees.count %></td>
  </tr>
  <% end %>   
</table>

```

4. Create an EventsController and corresponding routes to allow you to create an event (don’t worry about editing or deleting events), show a single event, and list all events.
```sh
$ rails generate controller Events

      create  app/controllers/events_controller.rb
      invoke  erb
      create    app/views/events
      invoke  test_unit
      create    test/controllers/events_controller_test.rb
      invoke  helper
      create    app/helpers/events_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/events.scss
```

```ruby
/app/controllers/events_controller.rb 

class EventsController < ApplicationController

  def new
  end

  def create
  end

  def show
  end

  def index
  end

end

/config/routes.rb

PrivateEvents::Application.routes.draw do
.
.
  resources :events, only: [:new, :create, :show, :index]
  get     '/events/new',   to: 'events#new'
  post    '/events/new',   to: 'events#create'
  get     '/event',        to: 'events#show'
  get     '/events',       to: 'events#index'
.
.


```

5. The form for creating an event should just contain a :description field.
```sh
This was done in point no. 1.
```

```erb
/app/views/events/new.html.erb

<% provide(:title, 'Create Event') %>
<h1>Create Event</h1>

<%= bootstrap_form_for(@event) do |f| %>
  <%= f.text_field :name %>
  <%= f.text_field :location %>
  <%= f.text_area :description %>
  <%= f.date_field :time%>
  <%= f.submit "Create Event",  class: "btn btn-lg btn-primary"  %>
<% end %>
<br>

```

6. The #create action should use the #build method of the association to create the new event with the user’s ID prepopulated. You could easily also just use Event’s ::new method and manually enter the ID but… don’t.
```ruby
/app/controllers/events_controller.rb 

class EventsController < ApplicationController
  before_action :log_in_user, only: [:create]

  def new
    if signed_in?
      @event = current_user.events.build
    else
      flash[:danger] = "Kindly log in to create an event"
      redirect_to signin_path
    end
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to event_path(id: @event.id)
    else
      render 'new'
    end
  end

  def index
    @events = Event.all
    @past_events = @events.past
    @upcoming_events = @events.upcoming
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @is_upcoming = Event.upcoming.include?(@event)
  end

  def signed_in?
    !current_user.nil?
  end

  private

  def event_params
    params.require(:event)
          .permit(:name, :description, :location, :time)
  end

  def log_in_user
    unless signed_in?
      flash[:danger] = "Kindly log in to create an event"
      redirect_to login_path
    end
  end
end

```

7. The event’s Show page should just display the creator of the event for now.
```erb
/app/views/events/show.html.erb

<h1><%= @event.name %></h1>
<h1>Event details</h1>
<section>
  <div class="content">
    <h3>
      <%= @event.name %>
    </h3>
    <p>
      Description:
      <%= @event.description %>
    </p>
    <p>Location:
      <%= @event.location %>
    </p>
    <% if @is_upcoming %>
      <p>
        It will take place:
    <% else %>
        <p>It took place:
    <% end %>
        <%= @event.time.strftime("%d/%m/%Y") %>
      </p>
      <p>Created by:
        <%= @event.creator %></p>
    </div>
    <% if @user && @is_upcoming %>
      <% unless @user.attended_events.include?(@event) %>
        <%= link_to "Attend to event", attend_path(id: @event.id), method: :patch, class: "btn btn-primary" %>
      <% else %>
        <%= link_to "Not going anymore", not_attend_path(id: @event.id), method: :delete, class: "btn btn-danger" %>
      <% end %>
    <% end %>
    <h3>Attendees List</h3>
    <% if @event.attendees.any? %>
      <ol>
        <% @event.attendees.each do |attendee| %>
          <li><%= attendee.name %></li>
        <% end %>
      </ol>
    <% else %>
      <p>No attendees for this event yet</p>
    <% end %>
  </section>
```

### Event Attendance

1. Now add the association between the event attendee (also a User) and the event. Call this user the “attendee”. Call the event the “attended_event”. You’ll again need to juggle specially named foreign keys and classes and sources.

``` sh
$ rails generate migration Attendances
Running via Spring preloader in process 12251
      invoke  active_record
      create    db/migrate/20191126210650_attendances.rb
$ rails db:migrate
== 20191126210650 Attendances: migrating ======================================
-- create_table(:attendances)
   -> 0.0017s
== 20191126210650 Attendances: migrated (0.0018s) =============================
```
```ruby
#/db/migrate/20191126210650_attendances.rb
class Attendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.integer :attendee_id
      t.integer :attended_event_id

      t.timestamps
    end
  end
end
```
```sh
$ rails generate model Attendance
Running via Spring preloader in process 12585
      invoke  active_record
      create    db/migrate/20191126210941_create_attendances.rb
      create    app/models/attendance.rb
      invoke    test_unit
      create      test/models/attendance_test.rb
      create      test/fixtures/attendances.yml
```

```ruby
#/app/models/attendance.rb
class Attendance < ApplicationRecord
  belongs_to :attendee, class_name: 'User'
  belongs_to :attended_event, class_name: 'Event'
end
```

2. Create and migrate all necessary tables and foreign keys. This will require a “through” table since an Event can have many Attendees and a single User (Attendee) can attend many Events… many-to-many.

```ruby
#/app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id
  has_many :people_attending, foreign_key: 'attended_event_id',
                              class_name: 'Attendance'
  has_many :attendees, through: :people_attending

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :time, presence: true

  def creator
    User.find_by(id: self.creator_id).name
  end
end
```
```ruby
class User < ApplicationRecord
  has_many :events, foreign_key: :creator_id
  has_many :attended, foreign_key: 'attendee_id', class_name: 'Attendance'
  has_many :attended_events, through: :attended
  .
  .
  .
end
```

3. Now make an Event’s Show page display a list of attendees.
```ruby
#/app/controllers/events_controller.rb
class EventsController < ApplicationController
.
.
.
def show
  @user = current_user
  @event = Event.find(params[:id])
  @is_upcoming = Event.upcoming.include?(@event)
end
 .
 .
 .
end
```
```erb
#/views/events/index.html.erb
<% provide(:title, 'Event List') %>

<h2 class="centered-text">Browse All Events</h2>
<% if @events.any? %>
<%= render partial: 'upcoming_past',
         locals: { upcoming: @upcoming_events, past: @past_events } %>
<% else %>
<h3 class="centered-text">No events created yet.</h3>
<% end %>

```

```erb
#/views/events/_upcoming_past.html.erb
<% if upcoming.any? || past.any? %>
  <h3 class="centered-text">Attending events:</h3>
  <div class="event-row">
    <div class="event-wrapper">
      <% if upcoming.any? %>
        <h4 class="centered-text">
          Upcoming Events (<%= upcoming.count %>)
        </h4>
        <div class="attending-events-container">
          <%= render partial: 'events/event', object: upcoming, as: 'events' %>
        </div>
      <% else %>
        <h4 class="centered-text">No upcoming events</h4>
      <% end %>
    </div>
    <div class="event-wrapper">
      <% if past.any? %>
        <h4 class="centered-text">
          Past Events (<%= past.count %>)
        </h4>
        <div class="attending-events-container">
          <%= render partial: 'events/event', object: past, as: 'events' %>
        </div>
      <% else %>
        <h4 class="centered-text">No past events</h4>
      <% end %>
    </div>
  </div>
<% else %>
  <h3 class="centered-text">No events attended or to attend yet.</h3>
<% end %>
```
2. Create and migrate all necessary tables and foreign keys. This will require a “through” table since an Event can have many Attendees and a single User (Attendee) can attend many Events… many-to-many.
:class_name, and :source).
```sh
/app/models/event.rb

class Event < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"

  has_many :invites, :foreign_key => "attended_event_id"
  has_many :attendees, :through => :invites

end
```

3. Now make an Event’s Show page display a list of attendees.
```erb
# app/view/users/show.html.erb

<% provide(:title, 'Participant List') %>
<h1>All Users</h1>
<div class="pagination-wrapper">
  <%= will_paginate %>
</div>
<ul class="users">
<% @users.each do |user| %>
  <li><%= link_to user.name, user %></li>
  <% end %>
</ul>
<%= will_paginate %>

```

4. Make a User’s Show page display a list of events they are attending.
```erb
# app/view/events/index.html.erb

<% provide(:title, 'Event List') %>

<h2 class="centered-text">Browse All Events</h2>
<% if @events.any? %>
  <%= render partial: 'upcoming_past',
         locals: { upcoming: @upcoming_events, past: @past_events } %>
<% else %>
  <h3 class="centered-text">No events created yet.</h3>
<% end %>
```

5. Modify the User’s Show page to separate those events which have occurred in the past (“Previously attended events”) from those which are occurring in the future (“Upcoming events”). You could do this by putting logic in your view. Don’t. Have your controller call separate model methods to retrieve each, e.g. @upcoming_events = current_user.upcoming_events and @prev_events = current_user.previous_events. You’ll get some practice with working with dates as well as building some queries.
```erb
/app/views/users/show.html.erb


<% provide(:title, 'Participant List') %>
<h1>All Users</h1>
<div class="pagination-wrapper">
  <%= will_paginate %>
</div>
<ul class="users">
<% @users.each do |user| %>
  <li><%= link_to user.name, user %></li>
  <% end %>
</ul>
<%= will_paginate %>


```

6. Modify the Event Index page to list all events, separated into Past and Upcoming categories. Use a class method on Event (e.g. Event.past).
```sh
/app/views/events/index.html.erb

<h1>Browse All Events</h1>

<h2>Upcoming</h2>
<%= render 'shared/table', object: @events_upcoming %>
<%= will_paginate @events_upcoming, :param_name => "upcoming" %>

<h2>Past</h2>
<%= render 'shared/table', object: @events_past %>
<%= will_paginate @events_past, :param_name => "past" %>
```

7. Refactor the “upcoming” and “past” methods into simple scopes (remember scopes??).
```sh
/app/models/event.rb

class Event < ActiveRecord::Base
.
.
  scope :upcoming,  -> { where('time >= ?', Time.now) }
  scope :past,      -> { where('time < ?',Time.now) }
.
.
end
```

8. Put navigation links across the top to help you jump around.
```erb
/app/views/layouts/_header.html.erb

<header class="navbar navbar-fixed-top navbar-inverse">
	<div class="container">
	  <%= link_to "Eventblitz app", root_path, id: "logo" %>
	  <nav>
	    <ul class="nav navbar-nav navbar-right">
	      <li><%= link_to "Home",   root_path %></li>
	      <li><%= link_to "Users",   users_path %></li>
	      <li><%= link_to "Event",   events_path  %></li>
	      <li><%= link_to "About",   about_path %></li>
	      <% if signed_in? %>
	        <li><%= link_to "#{current_user.name} (Log Out)", signout_path, method: "delete" %></li>
	      <% else %>
	        <li><%= link_to "Log In", signin_path %></li>
	      <% end %>
	    </ul>
	  </nav>
	</div>
</header>

/app/views/layouts/application.html.erb
.
.
  <body>     
    <%= render 'layouts/header' %>
    <div class="container">
.
.

```

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session.delete(:user_id) if signed_in?
    @current_user = nil
  end
end
```

## Setup seed database to populate events database

```ruby
# db/seed.rb

users = User.order(:created_at).take(10)
3.times do
  name = Faker::Lorem.sentence(8)
  location = Faker::Address.city
  description = Faker::Lorem.sentence(5)
  time = Faker::Time.forward(days = 365)
  users.each { |user| user.events.create!(name: name, location: location, description: description, time: time) }
end

users = User.order(:created_at).take(10)
5.times do
  name = Faker::Lorem.sentence(8)
  location = Faker::Address.city
  description = Faker::Lorem.sentence(5)
  time = Faker::Time.backward(days = 365)
  users.each { |user| user.events.create!(name: name, location: location, description: description, time: time) }
end
```

9. Extra Credit: Allow users to invite other users to events. Only allow invited users to attend an event.

10. Push to Github.

### Future enhancement

1. Email notification
2. In app notification

### Source

https://www.theodinproject.com/courses/ruby-on-rails/lessons/associations

### Github Repo

https://github.com/jcromerohdz/private-events

### Authors

* [@Christian](https://github.com/jcromerohdz)

* [@Gerald](https://github.com/geraldgsh)
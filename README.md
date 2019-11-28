# Microverse Project Title - Associations [Collaborative Project]
Ruby on Rails

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

5. Populate user database with this command "rails db:seed"

6. Run "bundle install" command to install all relevant gems

7. Run "rails server" command and open browser using "localhost:3000"

8. Sign in with default login (email: example@odin.org, password: foobar)

crh
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

```ruby
class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
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
class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end    
	end

	def show
		@user = User.find(params[:id])
	end

	private

    def user_params
        params.require(:user).permit(:name, :email)
    end

end

```
```erb
#app/views/users/new.html.erb
<h1>Sign Up</h1>

<%=  bootstrap_form_for @user, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10" do |f| %>
  <%= f.text_field :name %>
  <%= f.text_field :email %>

  <%= f.form_group do %>
      <%= f.submit "Create my account",  class: "btn btn-large btn-primary" %>
  <% end %>

<% end %>
```

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
# app/models/user.rb
class User < ApplicationRecord
  .
  .
  .

# Returns a random token.
def User.new_token
  SecureRandom.urlsafe_base64
end

def User.digest(token)
  Digest::SHA1.hexdigest(token.to_s)
end

private

  def create_remember_token
    self.remember_token = User.digest(User.new_token)
  end

end
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

```sh
It work!
```


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

app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @previous_events = @user.previous_events
      @upcoming_events = @user.upcoming_events
    end
  end

  def about
  end
end

app/views/static_pages/home.html.erb

<% provide(:title, "Home") %>
<% if logged_in? %>

  <%= render 'shared/user_home' %>

<% else %>

  <div class="jumbotron">
    <h1>Plan an Event</h1>
    <p class="lead">Keep track of events with your friends.  This is a simple app to organize your event planning.
       </p>
    <p><%= link_to "Create an Event", signup_path, class: "btn btn-lg btn-success" %></p>
  </div>

<% end %>

app/views/static_pages/about.html.erb

<% provide(:title, "About") %>

<h1>About</h1>

<p>The objective of this project is to design model associations and build a basic web app that emulates some of the core features of <a href="https://www.eventbrite.com" target="_blank">Everbrite</a>.</p>

<p>Feel free to create a dummy account; users can create events and indicate whether they're attending other events. </p>

View source code <a href="https://github.com/geraldgsh/private-events">here</a>.

/app/views/layout/application.html.erb

<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="container">
        <%= link_to "Eventbrite app", root_path, id: "logo" %>
        <nav>
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to "Home",   root_path %></li>
            <li><%= link_to "Users",   users_path %></li>
            <li><%= link_to "Event",   '#' %></li>
            <li><%= link_to "Log in", '#' %></li>
          </ul>
        </nav>
      </div>
    </header>
    <div class="container">
      <%= yield %>
    </div>
  </body>
</html>
``` 

0.2 Setup tester for main page
```sh
# test/controllers/static_pages_controller_test.rb

require 'test_helper'

class MainPageControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Event Planning APP"
  end

  test "should get home" do
    get main_page_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get about" do
    get main_page_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
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
app/assets/stylesheets/custom.scss
@import "bootstrap-sprockets";
@import "bootstrap";

/* mixins, variables, etc. */

$gray-medium-light: #eaeaea;

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
  color: $gray-light;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}


/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: white;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
  &:hover {
    color: white;
    text-decoration: none;
  }
}

/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid $gray-medium-light;
  color: $gray-light;
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
```

0.5 Flash error message setup for login page
```sh
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
### Setup and Sign In

1. Model the data for your application, including the necessary tables.
```sh
# User
a. Name
b. Email

# Event DB model (sign up)
a. Name
b. Location
c. Description
d. Date


# Attendance
a. Location
b. Host - event creator
c. who's going - attendance (can cancel)
d. foreign key - users who signed up 
```

2. Create a new Rails application and Git repo called private-events.
```sh
rails new private-events
```

3. Update your README to be descriptive and link to this project.

4. Build and migrate your User model. Don’t worry about validations.
```sh
rails generate scaffold User name:string email:string
      invoke  active_record
      create    db/migrate/20191122214153_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml
      invoke  resource_route
       route    resources :users
      invoke  scaffold_controller
      create    app/controllers/users_controller.rb
      invoke    erb
      create      app/views/users
      create      app/views/users/index.html.erb
      create      app/views/users/edit.html.erb
      create      app/views/users/show.html.erb
      create      app/views/users/new.html.erb
      create      app/views/users/_form.html.erb
      invoke    test_unit
      create      test/controllers/users_controller_test.rb
      create      test/system/users_test.rb
      invoke    helper
      create      app/helpers/users_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/users/index.json.jbuilder
      create      app/views/users/show.json.jbuilder
      create      app/views/users/_user.json.jbuilder
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/users.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.scss

$ rails db:migrate

== 20191122175002 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0032s
== 20191122175002 CreateUsers: migrated (0.0038s) =============================

User validations

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

app/models/user.rb
class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
end

Validation for unique signup

$ rails generate migration add_index_to_users_email
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
Running via Spring preloader in process 577
      invoke  active_record
      create    db/migrate/20191124024753_add_index_to_users_email.rb

db/migrate/[date]_add_index_to_users_email.rb
class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email, unique: true
  end
end

rails db:migrate
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
== 20191124024753 AddIndexToUsersEmail: migrating =============================
-- add_index(:users, :email, {:unique=>true})
   -> 0.0032s
== 20191124024753 AddIndexToUsersEmail: migrated (0.0038s) ====================

test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com

archer:
  name: Sterling Archer
  email: duchess@example.gov

lana:
  name: Lana Kane
  email: hands@example.gov

malory:
  name: Malory Archer
  email: boss@example.gov

<% 9.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
<% end %>

test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
.
.
.

User creation
db/seeds.rb

User.create!(name:  "batman",
             email: "batman@email.com")

79.times do |n|
  name  = Faker::Name.name
  email = "batman-#{n+1}@email.com"
  password = "password"
  User.create!(name:  name,
               email: email)

$ rails db:migrate:reset
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
Dropped database 'db/development.sqlite3'
Dropped database 'db/test.sqlite3'
Created database 'db/development.sqlite3'
Created database 'db/test.sqlite3'
== 20191122214153 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0030s
== 20191122214153 CreateUsers: migrated (0.0036s) =============================

== 20191124024753 AddIndexToUsersEmail: migrating =============================
-- add_index(:users, :email, {:unique=>true})
   -> 0.0035s
== 20191124024753 AddIndexToUsersEmail: migrated (0.0045s) ====================

$ rails db:seed


```

5. Create a simple Users controller and corresponding routes for #new, #create, and #show actions. You’ll need to make a form where you can sign up a new user and a simple #show page. You should be getting better and faster at this type of vanilla controller/form/view building.
```sh
$ rails generate controller Users
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

# /app/controllers/users_controller.rb

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
end

# /config/routes.rb

PrivateEvents::Application.routes.draw do
.
.
  resources :users, only: [:new, :create, :show, :index]
  match '/signup',  to: 'users#new',            via: 'get'
.
.
end

# /app/controller/users_controller.rb

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.fin(params[:id])
  end
.
.
end
```

6. Create a simple sign in function that doesn’t require a password – just enter the ID or name of the user you’d like to “sign in” as and click Okay. You can then save the ID of the “signed in” user in either the session hash or the cookies hash and retrieve it when necessary. It may be helpful to always display the name of the “signed in” user at the top.
```sh
$ rails generate controller Sessions

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

# /config/routes.rb

PrivateEvents::Application.routes.draw do
.
.
  resources :sessions, only: [:new, :create, :destroy]
  match '/login',  to: 'sessions#new',         via: 'get'
  match '/logout', to: 'sessions#destroy',     via: 'delete'
.
.
end

# /app/views/sessions/new.html.erb

<h1>Log in</h1>

<%= form_for(:session, url: sessions_path) do |f| %>

  <%= f.label :email %>
  <%= f.text_field :email %>

  <%= f.submit "Log in", class: "btn btn-large btn-primary" %>
<% end %>

app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user
      log_in user
      redirect_to user
    else
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end

app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
end

app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
end

 config/routes.rb
PrivateEvents::Application.routes.draw do
.
.
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
.
.
end

# Test for login sessions

test/controllers/sessions_controller_test.rb
require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get login_path
    assert_response :success
  end
end

```
## Setup main page

```sh
$ rails generate controller MainPage home about

      create  app/controllers/main_page_controller.rb
       route  get 'main_page/home'
      get 'main_page/about'
      get 'main_page/help'
      get 'main_page/contact'
      invoke  erb
      create    app/views/main_page
      create    app/views/main_page/home.html.erb
      create    app/views/main_page/about.html.erb
      create    app/views/main_page/help.html.erb
      create    app/views/main_page/contact.html.erb
      invoke  test_unit
      create    test/controllers/main_page_controller_test.rb
      invoke  helper
      create    app/helpers/main_page_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/main_page.scss

# config/routes.rb
PrivateEvents::Application.routes.draw do

  root 'static_pages#home'
  match '/about', to: 'main_page#about',     via: 'get'
.
.
end

# /app/controller/sessions_controller.rb

class SessionsController < ApplicationController

  def new
  end

  def create
  end

  def destroy
  end

end

# /app/controller/main_page_controller.rb

class MainPageController < ApplicationController
  def home
  end

  def about
  end

  def help
  end

  def contact
  end
end

# app/views/layouts/_header.html.erb

<div class="header">
  <ul class="nav nav-pills pull-right">
    <li><%= nav_link "Home", root_path %></li>
    <li><%= nav_link "Events", events_path %></li>
    <li><%= nav_link "Users", users_path %></li>
    <li><%= nav_link "About", about_path %></li>
    <% if logged_in? %>
       <li><%= link_to "#{current_user.name} (Log Out)", logout_path, method: "delete" %></li>
     <% else %>
      <li><%= link_to "Log In", login_path %></li>
    <% end %>
  </ul>
  <h3 class="text-muted">Private EventBrite</h3>
</div>

# /app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
<head>
  <title>PrivateEvents</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<body>

  <div class="container">
    <%= render 'layouts/header' %>
    <%= yield %>
    <div class="footer">
      <p>An event planning application, by <a href="https://twitter.com/Jberczel">@jberczel</a>.</p>
    </div>
  </div> <!-- /container -->

</body>
</html>


$ Setup remember token

$ rails generate migration add_remember_token_to_users remember_token:string
      invoke  active_record
      create    db/migrate/20191124172734_add_remember_token_to_users.rb

db/migrate/[date]_add_remember_token_to_users.rb
class AddRememberTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end

$ rails db:migrate

== 20191124162408 AddRememberDigestToUsers: migrating =========================
-- add_column(:users, :remember_digest, :string)
   -> 0.0027s
== 20191124162408 AddRememberDigestToUsers: migrated (0.0035s) ================

app/models/user.rb
class User < ApplicationRecord
  before_create :create_remember_token
.
.
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_token)
  end

end

```

Basic Events

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

<h1><%= @user.name %>
<small><%= @user.email %></small></h1>

<div class="text-center">
<%= link_to "Create New Event", new_event_path, class: "btn btn-success" %> 
</div>
<%= render 'shared/table', object: @user.events, as: 'events' %>
````

```erb
# app/views/shared/_table.html.erb

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

  <% object.each do |event| %>
  <tr>
    <td><%= event.time %></td>
    <td><%= link_to event.name, event_path(event) %></td>
    <td><%= event.location %></td>
    <td><%= link_to event.creator, user_path(event.creator) %></td>
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
This was done in point no. 2.
```

```erb
/app/views/events/new.html.erb

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
    @event = current_user.events.build
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
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
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

<% if signed_in? %>
  <div class="text-center"><%= render 'attend_form' %></div>
<% end %>

<p><b>Location: </b><%= @event.location %></p> 
<p><b>Host: </b><%= @event.creator %></p>

<p><%= @event.description %></p>
```

8. Create the Event Index page to display all events.
```erb
/app/views/events/index.html.erb

<h1>Browse All Events</h1>

<h2>Upcoming</h2>
<%= render 'shared/table', object: @events_upcoming %>
<%= will_paginate @events_upcoming, :param_name => "upcoming" %>

<h2>Past</h2>
<%= render 'shared/table', object: @events_past %>
<%= will_paginate @events_past, :param_name => "past" %>
```

Event Attendance
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
<h2 class="centered-text">Event List</h2>

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

          <%= render partial: 'shared/table', object: upcoming, as: 'events' %>

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

          <%= render partial: 'shared/table', object: upcoming, as: 'events' %>

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
```erb
#/views/shared/_table.html.erb
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
    <td><%= event.time %></td>
    <td><%= link_to event.name, event_path(event) %></td>
    <td><%= event.location %></td>
    <td><%= link_to event.creator, user_path(event.creator) %></td>
    <%
=begin %>
    <td class="text-center"><%= link_to event.attendees.count, event_path(event) %></td>
    <%
=end %>
  </tr>
  <% end %>   
</table>
```




```sh
$ rails generate controller invites_controller
      create  app/controllers/invites_controller.rb
      invoke  erb
      create    app/views/invites
      invoke  test_unit
      create    test/controllers/invites_controller_test.rb
      invoke  helper
      create    app/helpers/invites_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/invites.scss

/app/controllers/invites_controller.rb

class InvitesController < ApplicationController
  def create
    @event = Event.find(params[:invite][:attended_event_id])
    current_user.attend!(@event)
    redirect_to @event
  end

  def destroy
    @event = Invite.find(params[:id]).attended_event
    current_user.cancel!(@event)
    redirect_to @event
  end

end

$ rails generate model invite attendee_id:integer attendee_event_id:integer

      invoke  active_record
      create    db/migrate/20191124234809_create_invites.rb
      create    app/models/invite.rb
      invoke    test_unit
      create      test/models/invite_test.rb
      create      test/fixtures/invites.yml

$ rails db:migrate

== 20191124235002 CreateInvites: migrating ====================================
-- create_table(:invites)
   -> 0.0031s
== 20191124235002 CreateInvites: migrated (0.0040s) ===========================


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

4. Make a User’s Show page display a list of events they are attending.

5. Modify the User’s Show page to separate those events which have occurred in the past (“Previously attended events”) from those which are occurring in the future (“Upcoming events”). You could do this by putting logic in your view. Don’t. Have your controller call separate model methods to retrieve each, e.g. @upcoming_events = current_user.upcoming_events and @prev_events = current_user.previous_events. You’ll get some practice with working with dates as well as building some queries.
```sh
/app/views/users/show.html.erb

<p id="notice"><%= notice %></p>
<h1><%= @user.name %>
<small><%= @user.email %></small></h1>

<% if current_user?(@user) %>
<div class="text-center">
<%= link_to "Create New Event", new_event_path, class: "btn btn-success" %> 
</div>
<% end %>


<% if @upcoming_events.any? %>
<h2>Upcoming</h2>
<%= render 'shared/table', object: @upcoming_events %>
<% end %>

<% if @previous_events.any? %>

<h2>Attended</h2>
<%= render 'shared/table', object: @previous_events %>

<% end %>

<% if @user.events.any? %>
<h2>Created by <%= @user.name%></h2>

<%= render 'shared/table', object: @user.events %>
<% end %>

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
  belongs_to :creator, :class_name => "User"

  has_many :invites, :foreign_key => "attended_event_id"
  has_many :attendees, :through => :invites

  scope :upcoming, -> { where("Date >= ?", Date.today).order('Date ASC') }
  scope :past, -> { where("Date < ?", Date.today).order('Date DESC') }

end
```

8. Put navigation links across the top to help you jump around.
```sh
/app/views/layouts/_header.html.erb

<div class="container">
  <%= link_to "Eventbrite app", root_path, id: "logo" %>
  <nav>
    <ul class="nav navbar-nav navbar-right">
      <li><%= link_to "Home",   root_path %></li>
      <li><%= link_to "Users",   users_path %></li>
      <li><%= link_to "Event",   '#' %></li>
      <% if logged_in? %>
        <li><%= link_to "#{current_user.name} (Log Out)", logout_path, method: "delete" %></li>
      <% else %>
        <li><%= link_to "Log In", login_path %></li>
      <% end %>
    </ul>
  </nav>
</div>

/app/views/layouts/application.html.erb
.
.
  <body>     
    <%= render 'layouts/header' %>
    <div class="container">
.
.

```

9. Extra Credit: Allow users to invite other users to events. Only allow invited users to attend an event.
```sh
$ rails generate migration add_index_to_invite
      invoke  active_record
      create    db/migrate/20191125004125_add_index_to_invites.rb

db/migrate/[date]_add_index_to_invites.rb 

class AddIndexToInvites < ActiveRecord::Migration
  def change
    add_index :invites, :attendee_id
    add_index :invites, :attended_event_id
    add_index :invites, [:attendee_id, :attended_event_id], unique: true
  end
end

$ rails generate migration add_title_to_events
      invoke  active_record
      create    db/migrate/20191125004337_add_title_to_events.rb

/db/migrate/[date]_add_title_to_events.rb 

class AddTitleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
  end
end

/app/controllers/invitess_controller.rb 
class InvitesController < ApplicationController
  def create
    @event = Event.find(params[:invite][:attended_event_id])
    current_user.attend!(@event)
    redirect_to @event
  end

  def destroy
    @event = Invite.find(params[:id]).attended_event
    current_user.cancel!(@event)
    redirect_to @event
  end

end

```

$ rails db:migrate
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
== 20191125004125 AddIndexToInvites: migrating ================================
-- add_index(:invites, :attendee_id)
   -> 0.0031s
-- add_index(:invites, :attended_event_id)
   -> 0.0012s
-- add_index(:invites, [:attendee_id, :attended_event_id], {:unique=>true})
   -> 0.0017s
== 20191125004125 AddIndexToInvites: migrated (0.0082s) =======================

== 20191125004337 AddTitleToEvents: migrating =================================
-- add_column(:events, :title, :string)
   -> 0.0035s
== 20191125004337 AddTitleToEvents: migrated (0.0044s) ========================
```

10. Push to Github.
development

feature-branch

Kill puma server
ps ax to list
kill -9 <pid>

To purge and reseed database

rake db:drop
rake db:create
rake db:schema:load
rake db:seed 

and then you run:

rake db:migrate
rake db:test:prepare
rake db:prepare

### Source

https://www.theodinproject.com/courses/ruby-on-rails/lessons/associations

### Github Repo

https://github.com/jcromerohdz/private-events
s
### Authors

* [@Christian](https://github.com/jcromerohdz)

* [@Gerald](https://github.com/geraldgsh)


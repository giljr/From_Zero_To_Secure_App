# 🔐 AuthApp – Authentication System in Rails 8

Let’s Get Started!

This tutorial is based on Chris Oliver’s [GoRails guide](https://gorails.com) 👌  
> **Note:** If you get stuck, please see my [repository](#).

---

## 🚀 0. Project Setup

```bash
rails new auth_app
cd auth_app
code .
```

🌐 1. Set Up Routes

In `config/routes.rb`:
```ruby
resource :registration, only: [:new, :create]
resource :session, only: [:new, :create, :destroy]
resource :password_reset, only: [:new, :create, :edit, :update]
resource :password, only: [:edit, :update]
root "main#index"
```
👤 2. Build Registrations Controller

Create `app/controllers/registrations_controller.rb` with new, create, index, and show actions.

🖊 3. Create Sign-Up View

File: `app/views/registrations/new.html.erb`
Contains the form for signing up a user.

🧱 4. Generate the User Model
```bash
rails generate model User email:string password_digest:string
rails db:migrate
```

🔐 5. Add has_secure_password to User

In `app/models/user.rb`:
```ruby
has_secure_password
validates :email, presence: true
normalizes :email, with: ->(email) { email.strip.downcase }
```
🧠 6. Add Login/Logout Methods

In `app/controllers/application_controller.rb`:
```rubt
def login(user)
  Current.user = user
  reset_session
  session[:user_id] = user.id
end

def logout(user)
  Current.user = nil
  reset_session
end
```
🧱 7. Enable bcrypt

Uncomment in your `Gemfile`:

    gem "bcrypt", "~> 3.1.7"

Then run:

    bundle install

🧭 8. Add Current Attributes

File: `app/models/current.rb`
```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
```
🔎 9. Add Helper Methods to ApplicationController
```ruby
def authenticate_user!
  redirect_to root_path, alert: "You must be logged in to do that :/" unless user_signed_in?
end

def current_user
  Current.user ||= authenticate_user_from_session
end
helper_method :current_user

def authenticate_user_from_session
  User.find_by(id: session[:user_id])
end

def user_signed_in?
  current_user.present?
end
helper_method :user_signed_in?
```
🧭 10. Navigation & Flash Messages

In `app/views/layouts/application.html.erb`:
```ruby
<div><%= notice %></div>
<div><%= alert %></div>

<% if user_signed_in? %>
  <%= link_to "Edit Password", edit_password_path %>
  <%= button_to "Log Out", session_path, method: :delete %>
<% else %>
  <%= link_to "Sign Up", new_registration_path %>
  <%= link_to "Log In", new_session_path %>
<% end %>
```
🏠 11–13. Main Controller and Homepage

    rails generate controller Main index

Then set the root route:

    root "main#index"

🔑 14. Sessions Controller (Login/Logout)

Create `app/controllers/sessions_controller.rb` to handle authentication logic.

🧾 15. Login View

File: `app/views/sessions/new.html.erb`

Contains login form and password reset link.

✏️ 16. PasswordsController

In `app/controllers/passwords_controller.rb`

Implements edit and update actions for changing password.

🛠 17. Password Edit View

File: `app/views/passwords/edit.html.erb`

Allows logged-in users to update their password securely.

🔐 18. Token Generation for User Model

In `app/models/user.rb`:
```ruby
generates_token_for :password_reset, expires_in: 15.minutes do
  password_salt&.last(10)
end

generates_token_for :email_confirmation, expires_in: 24.hours do
  email
end
```
🔁 19. Password Reset Controller

Create `app/controllers/password_resets_controller.rb`

Handles flow for requesting and resetting forgotten passwords.

🧾 20. Reset Password View

File: `app/views/password_resets/edit.html.erb`

Form for user to input and confirm a new password using a valid token.

✅ 21. Final Steps

    Confirm your email token generation is secure.

    Implement your PasswordMailer.

    Enjoy a lightweight, modern authentication flow!

📦 Run the App

    bin/dev

Test signup, logout, login, and password reset flows.

🧠 Credits

Inspired by [Chris Oliver’s GoRails guide]().
This version was crafted to be lean and educational. 

Feel free to fork and customize it.

📜 License

MIT License
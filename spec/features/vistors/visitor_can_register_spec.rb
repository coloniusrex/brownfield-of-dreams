require 'rails_helper'

describe 'As a guest user' do
  it "When I visit the home page I can click a link to register, and am taken to the register path" do
    email = 'jimbob@aol.com'
    first_name = 'Jim'
    last_name = 'Bob'
    password = 'password'
    password_confirmation = 'password'

    visit '/'

    click_on 'Register'

    expect(current_path).to eql('/register')

    fill_in 'user[email]', with: email
    fill_in 'user[first_name]', with: first_name
    fill_in 'user[last_name]', with: last_name
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on 'Create Account'

    expect(current_path).to eql(dashboard_path)
    expect(page).to have_content("Logged in as #{first_name}.")
    expect(page).to have_content("This account has not yet been activated. Please check your email.")

    expect(page).to have_content(email)
    expect(page).to have_content(first_name)
    expect(page).to have_content(last_name)
    expect(page).to_not have_content('Sign In')
  end

  it "When I fill out the registration form incomplete, I see flash errors and redirect to the register form" do
    email = 'jimbob@aol.com'
    first_name = 'Jim'
    last_name = 'Bob'
    password = 'password'
    password_confirmation = 'password'

    visit '/register'

    fill_in 'user[email]', with: email
    fill_in 'user[first_name]', with: first_name
    fill_in 'user[last_name]', with: last_name

    click_on 'Create Account'

    expect(current_path).to eql('/register')
    expect(page).to have_content("Password can't be blank")
  end
end

describe 'As a guest user who has registered but has not activated my account' do

  it "I can visit the path provided in the email and activate my account" do
    email = 'jimbob@aol.com'
    first_name = 'Jim'
    last_name = 'Bob'
    password = 'password'
    password_confirmation = 'password'

    visit '/register'
    fill_in 'user[email]', with: email
    fill_in 'user[first_name]', with: first_name
    fill_in 'user[last_name]', with: last_name
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on 'Create Account'

    user = User.last
    expect(current_path).to eql(dashboard_path)
  end
end

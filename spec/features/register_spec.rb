require 'spec_helper'

feature "user sign-up" do
  scenario "the user registers with a password and password confirmation" do
    visit '/'
    click_link 'Register'
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button 'ok'
    expect(page).to have_content 'Welcome batman@hotmail.com'
  end

  scenario "the user registers with a password and received an error if confirmation doesn't match" do
    visit '/'
    click_link 'Register'
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'ro'
    click_button "ok"
    expect(current_path).to eq '/sign-up'
    expect(page).to have_content 'Passwords do not match. Please try again'
  end

  scenario "not redirecting if invalid email format" do
    visit '/sign-up'
    fill_in :email, with: 'batman'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button "ok"
    expect(current_path).to eq '/sign-up'
  end

  scenario "not redirecting if no email given" do
    visit '/sign-up'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button "ok"
    expect(current_path).to eq '/sign-up'
  end

  scenario "not adding emails already in the database" do
    visit '/sign-up'
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button "ok"
    visit '/sign-up'
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button "ok"
    expect(current_path).to eq '/sign-up'
    expect(page).to have_content 'Email is already taken'
  end
end

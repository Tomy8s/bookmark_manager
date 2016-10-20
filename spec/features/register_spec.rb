require 'spec_helper'

feature "user sign-up" do
  scenario "the user registers with a password and password confirmation" do
    visit "/"
    click_button "Register"
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'robin'
    click_button "ok"
    expect(page).to have_content "Welcome batman@hotmail.com"
  end

  scenario "the user registers with a password and received an error if confirmation doesn't match" do
    visit "/"
    click_button "Register"
    fill_in :email, with: 'batman@hotmail.com'
    fill_in :password, with: 'robin'
    fill_in :password_confirmation, with: 'ro'
    click_button "ok"
    expect(page).to_not have_content "Welcome batman@hotmail.com"
  end
end

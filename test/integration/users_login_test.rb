# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_not logged_in?
  end

  test 'login with valid information' do
    log_in_as @user
    assert_redirected_to root_path
    assert logged_in?
  end

  test 'login with valid information followed by logout' do
    log_in_as @user
    assert logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
  end
end

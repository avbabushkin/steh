require 'rails_helper'
require_relative '../support/utilities.rb'

RSpec.describe "UserPages", type: :request do
  
  subject { page }

  describe "profile page" do
    let(:user) { FactoryBot.create(:user) }
    before { visit user_path(user) }


    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "User pages" do
    before { visit signup_path } 
    
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      
      it "should not new a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content('error') }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Password is too short') }
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Email is invalid') }
      end

      # почитать DSL RSpec и Capibara, чтоб отрефакторить реализацию теста ниже
      # Тест ниже делжен проверять наличие текста ошибки 'Email has already
      # been taken' на странице регистрации # 'signup_path', 
      # после заполнения поля уже существующим в БД emailx 
      
      describe "after submission" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end
        
        before { click_button submit }
        before { visit signup_path }

        before do
          fill_in "Email", with: "user@example.com" # заполение поля существующим в бд email
        end

        before { click_button submit }
        
        it { should have_content('Email has already been taken') }
      end
      
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end


      it "should new a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end

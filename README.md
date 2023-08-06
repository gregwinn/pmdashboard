# README
This is a demo project using rails 7.0.6 and ruby 3.1.2

## Setup
1. Clone the repo
2. Run `bundle install`
3. Run `rails db:create`
4. Run `rails db:migrate`
5. Run `rails db:seed`
6. Start redis server
7. Run `bundle exec sidekiq`
8. Run `rails s`

## Usage
1. Go to `http://localhost:3000`
2. Login with One of the following users:
    - Project Manager: `pm_test@test.com`, `test1234`
    - Employee: `employee_test@test.com`, `test1234`
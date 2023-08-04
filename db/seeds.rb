# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Test users for development and demo purposes
# You can run rails db:seed to create these users
pm_user = {email: "pm_test@test.com", password: "test1234", role: :pm}
employee_user = {email: "employee_test@test.com", password: "test1234", role: :employee}
User.create([pm_user, employee_user])

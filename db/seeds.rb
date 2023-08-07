# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Test users for development and demo purposes
# You can run rails db:seed to create these users

# Create a PM and an employee
pm_user = {email: "pm_test@test.com", password: "test1234", role: :pm, first_name: "Michael", last_name: "Scott"}
employee_user = {email: "employee_test@test.com", password: "test1234", role: :employee, first_name: "Dwight", last_name: "Schrute"}
pm = User.create(pm_user)
employee = User.create(employee_user)

# Create a project

project1 = Project.create(name: "Test Project One", description: "This is a test project", user: pm, due_date: 1.week.from_now)
project2 = Project.create(name: "Test Project Almost due", description: "This is a test project", user: pm, due_date: 1.day.from_now)

# Create a work task with a parent task
work_task1 = WorkTask.create(name: "Test Work Task One", description: "This is a test work task", user: pm, due_date: 1.week.from_now, project: project1, user_assignment_id: employee.id)
work_task2 = WorkTask.create(name: "Test Work Task Two", description: "This is a test work task", user: pm, due_date: 1.day.from_now, project: project1, user_assignment_id: employee.id)
work_task3 = WorkTask.create(name: "Subtask Work Task Three", description: "This is a test work task", user: pm, due_date: 1.week.from_now, project: project1, parent: work_task1, user_assignment_id: employee.id)
work_task4 = WorkTask.create(name: "Subtask Work Task Four", description: "This is a test work task", user: pm, due_date: 2.days.from_now, project: project1, parent: work_task1, user_assignment_id: employee.id)
work_task5 = WorkTask.create(name: "Test Work Task Five", description: "This is a test work task", user: pm, due_date: 1.week.from_now, project: project2, user_assignment_id: employee.id)
work_task6 = WorkTask.create(name: "Test Work Task Six", description: "This is a test work task", user: pm, due_date: 1.day.from_now, project: project2, user_assignment_id: employee.id)
work_task7 = WorkTask.create(name: "Subtask Work Task Seven", description: "This is a test work task", user: pm, due_date: 1.week.from_now, project: project2, parent: work_task5, user_assignment_id: employee.id)


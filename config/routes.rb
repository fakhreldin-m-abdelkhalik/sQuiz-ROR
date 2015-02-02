Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  
  namespace :api do
  
    devise_scope :student do
      post 'students/registrations' => 'StudentsRegistrations#create', as: 'student_register'
      post 'students/sessions' => 'StudentsSessions#create', as: 'student_login'
      delete 'students/sessions' => 'StudentsSessions#destroy', as: 'student_logout'
    end

    devise_scope :instructor do
      post 'instructors/registrations' => 'InstructorsRegistrations#create', as: 'instructor_register'
      post 'instructors/sessions' => 'InstructorsSessions#create', as: 'instructor_login'
      delete 'instructors/sessions' => 'InstructorsSessions#destroy', as: 'instructor_logout'
    end

  end
end

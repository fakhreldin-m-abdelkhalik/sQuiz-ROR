Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  
  namespace :api do
  
    devise_scope :student do
      post 'students/signup' => 'students_registrations#create', as: 'student_register'
      post 'students/signin' => 'students_create#create', as: 'student_login'
      delete 'students/signout' => 'students_destroy#destroy', as: 'student_logout'
    end

    devise_scope :instructor do
      post 'instructors/signup' => 'instructors_registrations#create', as: 'instructor_register'
      post 'instructors/signin' => 'instructors_create#create', as: 'instructor_login'
      delete 'instructors/signout' => 'instructors_destroy#destroy', as: 'instructor_logout'
    end

  end
end

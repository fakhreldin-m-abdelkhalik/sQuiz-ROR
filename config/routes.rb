Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  
  namespace :api do
  
    devise_scope :student do
      post 'students/registrations' => 'students_registrations#create', as: 'student_register'
      post 'students/sessions' => 'students_sessions#create', as: 'student_login'
      delete 'students/sessions' => 'students_sessions#destroy', as: 'student_logout'
    end

    devise_scope :instructor do
      post 'instructors/registrations' => 'instructors_registrations#create', as: 'instructor_register'
      post 'instructors/sessions' => 'instructors_sessions#create', as: 'instructor_login'
      delete 'instructors/sessions' => 'instructors_sessions#destroy', as: 'instructor_logout'
    end

  end

    post 'groups/student/add' => 'groups#add'
    post 'groups/student/remove' => 'groups#remove'
end

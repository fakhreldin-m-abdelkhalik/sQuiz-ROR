Rails.application.routes.draw do

  devise_for :instructors
  devise_for :students
  
  namespace :api do
    resources :quizzes, except: [:update,:edit,:index,:show]
    get '/student/quizzes', to: 'quizzes#student_index'
    get '/instructor/quizzes', to: 'quizzes#instructor_index'
    get '/student/quizzes/:id', to: 'quizzes#student_show'
    get '/instructor/quizzes/:id', to: 'quizzes#instructor_show'
    post '/quizzes/publish/:id', to: 'quizzes#publish'

    post '/quizzes/addquestion/:quiz_id', to: 'quizzes#add_question'
    patch '/quizzes/editquestion/:question_id', to: 'quizzes#edit_question'

    get '/student/groups', to: 'groups#student_index'
    get '/instructor/groups', to: 'groups#instructor_index'
    get '/instructor/groups/:id', to: 'groups#instructor_show'

    post 'students/signup', to: 'registrations#student_create'
    post 'instructors/signup', to: 'registrations#instructor_create'

    post 'signin', to: 'sessions#instructor_create'

    delete '/student/signout', to: 'signout#student_destroy'
    delete 'instructor/signout', to: 'signout#instructor_destroy'

    # devise_scope :student do
    #   post 'students/signup' => 'students_registrations#create', as: 'student_register'
    #   post 'students/signin' => 'students_create#create', as: 'student_login'
    #   delete 'students/signout' => 'students_destroy#destroy', as: 'student_logout'
    # end

    # devise_scope :instructor do
    #   post 'instructors/signup' => 'instructors_registrations#create', as: 'instructor_register'
    #   post 'instructors/signin' => 'instructors_create#create', as: 'instructor_login'
    #   delete 'instructors/signout' => 'instructors_destroy#destroy', as: 'instructor_logout'
    # end
    
    post 'groups/student/add' => 'groups#add'
    post 'groups/student/remove' => 'groups#remove'
     post 'groups/create'=>'groups#create'
    delete 'groups/delete'=>'groups#destroy'
  end

end

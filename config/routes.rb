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

    devise_scope :instructor do
      post 'instructors/signup', to: 'registrations#instructor_create'
    end

    devise_scope :student do
      post 'students/signup', to: 'registrations#student_create'
    end

    post 'signin', to: 'sessions#instructor_create'

    get '/quizzes/:quiz_id/group/:group_id', to: 'quizzes#group_result'

    delete 'student/signout', to: 'signout#student_destroy'
    delete 'instructor/signout', to: 'signout#instructor_destroy'
    
    post 'groups/student/add' => 'groups#add'
    post 'groups/student/remove' => 'groups#remove'
    post 'groups/create'=>'groups#create'
    post 'student/mark_quiz', to: 'quizzes#mark_quiz'
    delete 'groups/delete'=>'groups#destroy'
  end

end

class ExamsController < ApplicationController
  
  
  before_filter :exam_question_list, :authenticate_user!
  
  def index
    @_array = session[:array]
    @questions = Question.find(@_array)
    QuizOption.find_by_user_id(current_user).destroy
    respond_to do |format|
      format.html # index.html.erb
      format.json { head :ok }
    end    
  end
  
  def testpaper
    @quiz_option = QuizOption.new
#    @_array = session[:array]
    @questions = Question.find(session[:array])
    @questions =  Kaminari.paginate_array(@questions).page(params[:page]).per(1)
    
    respond_to do |format|
      format.html # testpaper.html.erb
      format.json { render json: @question }   
    end  
  end

  def testpapernext

    @_quiz_option_array = params[:quiz_option]
    @question_option = @_quiz_option_array["question"]
    
    @question = Question.find(@question_option)
    
    @quiz_option = QuizOption.find_by_question(@question_option)
    
    if @quiz_option.nil?
      @quiz_option = QuizOption.new(params[:quiz_option])
      @quiz_option.save
      session[:quiz_option_count] += 1
    else
      @quiz_option.update_attributes(params[:quiz_option])
    end
    
    @answer =  @question.answers.find(@_quiz_option_array[:answer])
    if @answer.correct
      @quiz_option.update_attributes(:correct => true)
      @question.increment!(:right, by=1)
    else
      @quiz_option.update_attributes(:correct => false)
      @question.increment!(:wrong, by=1)
    end
#    @_array = session[:array]
#    session[:array] = @_array.drop(1)
    @quiz_option_count = QuizOption.count
    if (@quiz_option_count >= 75)
      flash[:notice] = "Well done! You hace successfully completed the test please press link below for test score results"
      session[:quiz_option_count] = @quiz_option_count
    else
      flash[:notice] = "Option is updated, click Next_Question"
    end
    
    redirect_to :back
  end
  
  def testscore
    @quiz_option_count_correct = QuizOption.count(:conditions => {:correct => true})
    @_quiz_option_test_array = params[:quiz_option]
    @_quiz_option_question = Question.find(@_quiz_option_test_array)
    
    respond_to do |format|
      format.html # testscore.html.erb
      format.json { head :ok }
    end
  end 
       
  private 
  
  def exam_question_list    
  session[:array] ||= Question.generate_random
  end  
  
end
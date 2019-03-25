class QuestionsController < ApplicationController

  def index
    @questions = Question.all
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    #byebug
      a = [params[:choice1], params[:choice2], params[:choice3], params[:choice4]]
      answer = a.reject { |c| c.empty? }
      answer.each_with_index do |ans, index|
        @answer = @question.answers.new
        @answer.answer = ans
          if params[:correct_choice].to_i == index + 1
            @answer.is_correct = true
          else
            @answer.is_correct = false
          end
        @answer.save
        end
    @question.save!
    #redirect_to questions_path
    respond_to do |format|
      format.js
    end
  end

  def edit
    @question = Question.find(params[:id])
    @question.answers
  end

  def update
    @question= Question.find(params[:id])
    #byebug
    @question.update(question_params)
    @b = [params[:choice1], params[:choice2], params[:choice3], params[:choice4]]
      #answer = @b.reject { |c| c.empty? }
      answer = @b.compact 
      @question.answers.each_with_index do |a, index|
          if params[:question][:correct_choice].to_i == index + 1
            a.update(:answer => answer[index], :is_correct => true)
          else
            a.update(:answer => answer[index], :is_correct => false)
          end
        end
        redirect_to games_path
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:question, :game_id)
  end
end

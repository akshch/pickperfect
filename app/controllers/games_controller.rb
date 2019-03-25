class GamesController < ApplicationController

  before_action :authenticate_admin!, only: [:index,:create, :edit, :update, :destroy]
  before_action :restrict_access, only: [:game_question]

  #before_action :restrict_access, only: [:game_question]

  #[POST] 'game/question
  def game_question
      #q = Game.where(id: params[:game_id]).first   // 
      q = Game.find(params[:game_id])
      @response = []
            q.questions.each do |question|
              @answers = []       
              @response.push(id: question.id, question: question.question, answer:@answers)
                question.answers.each do |answer|
                  if answer.answer.present?
                    @answers.push(id: answer.id, answer: answer.answer)
                  end
                end
            end

        #    @response =  @responses.all?{|h| h.values.all?(&:nil?)}

      render json: {status: 'SUCCESS', message: 'game-question', data:@response}, status: :ok
    end

    def testing_live
      #byebug
          @game = Game.find(params[:id])
          @game.submission = 1

          respond_to do |format|
            if @game.save
              format.html { render :nothing => true }
              format.js
            end
          end
          #redirect_to games_path
    end

    def deleting_live
      #byebug
          @game = Game.find(params[:id])
          @game.submission = 0

          respond_to do |format|
            if @game.save
              format.html { render :nothing => true }
              format.js
            end
          end
          #redirect_to games_path
    end

    def live 
     @games = Game.all.where(:submission => 1)
    end

  def index
    @games = Game.all
    @game = Game.new
  end

  def create 
    @game = Game.new(game_params)
    @game.submission = 0
    @game.save
    redirect_to games_path
  end

  def edit 
    @game = Game.find(params[:id])
  end

  def show 
    @game = Game.find(params[:id])
    @question = Question.where(game_id: params[:game_id])
    @question = Question.new
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to games_path
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :location, :expiry, :submission, :credits_required, :description, :published, {category_ids: []}, {location_ids: []}, :avatar )
  end
end



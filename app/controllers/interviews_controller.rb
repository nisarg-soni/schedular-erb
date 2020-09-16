class InterviewsController < ApplicationController
    before_action :setter, only: [:show, :edit, :update, :destroy]

    def index
        @interviews = Interview.all
        @interview = Interview.new
    end

    # def show
    # end

    def edit
    end

    def create
        @interview = Interview.new(parameters)

        @interviewer = User.find_by(:email => params[:interviewer])
        @candidate = User.find_by(:email => params[:candidate])

        if !@interviewer || !@candidate
            redirect_to root_url, notice: 'User not available.'
        else
            if @interview.save
                @interview.users << interviewer
                @interview.users << candidate
                # mail functionality goes here
                redirect_to root_url, notice: 'Interview creation successfull.'
            else
                redirect_to root_url, notice: 'Interview creation unsuccessfull. Error occured'
            end
        end


    end

    def update
        
    end

    # def new
    # end

    def destroy
    end

    private

    def setter
        @interview = Interview.find(params[:id])
    end

    def parameters
        params.require(:interview).permit(:topic, :date, :start, :finish)
    end
end

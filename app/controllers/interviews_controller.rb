class InterviewsController < ApplicationController
    before_action :setter, only: [:show, :edit, :update, :destroy]

    def index
        @interviews = Interview.all
        @interview = Interview.new
        @candidate
        @interviewer
    end

    def edit
        participants = @interview.users 
        if participants[0].role
            @interviewer = participants[0].email
            @candidate = participants[1].email 
        else
            @interviewer = participants[1].email
            @candidate = participants[0].email
        end
    end

    def create
        @interview = Interview.new(parameters)
        
        @interviewer = User.find_by(:email => params[:interview][:interviewer])
        @candidate = User.find_by(:email => params[:interview][:candidate])
       

        if !@interviewer || !@candidate
            redirect_to root_url, notice: 'User not available.'
        else
            if !overlaps(@interview, @interviewer,@candidate)
                if @interview.save
                    @interview.users << @interviewer
                    @interview.users << @candidate
                    # mail functionality goes here
                    redirect_to root_url, notice: 'Interview creation successfull.'
                else
                    redirect_to root_url, notice: 'Interview creation unsuccessfull. Error occured'
                end
            else
                redirect_to root_url, notice: 'Interview overlapping with existing interview'
            end
        end
    end

    def update
        @old_interview = Interview.find(params[:id])
        @cur_interview = Interview.new(parameters)
        @cur_interview.id = params[:id]

        @interviewer = User.find_by(:email => params[:interviewer])
        @candidate = User.find_by(:email => params[:candidate])

        if !@interviewer || !@candidate
            redirect_to root_url, notice: 'User not available.'
        else
            if overlaps(@cur_interview,@interviewer,@candidate)
                redirect_to root_url, notice: 'Interview overlapping with existing interview'
            else
                if @interview.update_attributes(parameters)
                    @interview.users.clear
    
                    @interview.users << @interviewer
                    @interview.users << @candidate
                    # mail functionality goes here
                    redirect_to root_url, notice: 'Interview updation successfull.'
                else
                    redirect_to root_url, notice: 'Interview updation unsuccessfull. Error occured'
                end
            end
        end
    end

    def destroy
        @interview = Interview.find(params[:id])
        if @interview.destroy
            redirect_to root_url, notice: 'Interview deletion successfull.'
        else
            redirect_to root_url, notice: 'Interview deletion unsuccessfull. Error occured'
        end
    end

    private

    def setter
        @interview = Interview.find(params[:id])
    end

    def parameters
        params.require(:interview).permit(:topic, :date, :start, :finish)
    end

    def overlaps(interview,interviewer,candidate)
        list = []
        
        list =list + interviewer.interviews
        list =list + candidate.interviews
        puts list
        if list.length()
            list.each do |inter|
                if inter.id!=interview.id and inter.date==interview.date and !((interview.start>=inter.finish) or (interview.finish<=inter.start))
                    return true
                end
            end
        end
        return false
    end
end

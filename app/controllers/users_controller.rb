class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new
        # @ex_user = User.where(:email => params[:email])
        # puts @ex_user
        if User.exists?(:email => params[:email])
            # puts @ex_user.name
            redirect_to root_url, notice: 'User email in use.'
        else
            @user.email = params[:email]
            @user.name = params[:name]
            if params[:role]=='interviewer'
                @user.role=true
                @user.has_resume= false
            else
                @user.role=false
                if params[:file]
                    @user.has_resume=true 
                else 
                    @user.has_resume=false
                end
            end

            if @user.save
                if !@user.role
                    @resume = Resume.new(parameters)
                    @resume.user_id = @user.id 
                    
                    if @resume.save!
                        puts "resume saved"
                    else
                        puts @resume.errors.full_messages
                    end
                end
                # @user.resume << Resume.new(parameters)
                redirect_to root_url, notice: 'User creation success.'
            else
                redirect_to root_url, notice: 'User creation unsuccessfull.'
            end
        end
    end

    private

    def parameters
        params.permit(:file)
    end
    
end

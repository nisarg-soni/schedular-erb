class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new
        puts "here"
        @user.email = params[:email]
        @user.name = params[:name]
        if params[:role]=='interviewer'
            @user.role=true
            @user.has_resume= false
        else
            @user.role=false
            if params[:resume]
                @user.has_resume=true 
            else 
                @user.has_resume=false
            end
        end

        # puts @user.email
        # puts @user.name
        # puts @user.role
        # puts @user.has_resume
        
        if @user.save
            @resume = Resume.new(parameters)
                @resume.users_id = @user.id 
                # puts @resume.users_id
                # puts @resume.file_file_name
                # puts @resume.file_content_type
                # puts @resume.file_file_size
                # puts @resume.file_updated_at
                if @resume.save
                    puts "resume saved"
                else
                    puts "oops"
                end
            redirect_to root_url, notice: 'User creation success.'
        else
            redirect_to root_url, notice: 'User creation unsuccessfull.'
        end
    end

    private

    def parameters
        params.permit(:file)
    end
    
end

class InterviewMailer < ApplicationMailer
    default from: 'noreply@schedular.com'

    def create_mail (send_to,reciever_name,topic,date,start,finish,interviewer,candidate)
        mail(to: send_to, subject: 'An interview has been scheduled!')
    end

    def update_mail (send_to,reciever_name,topic,date,start,finish,interviewer,candidate)
        mail(to: send_to, subject: 'You interview has been updated.' )
    end

    def reminder_mail (send_to,reciever_name)
        mail(to: send_to, subject: 'Reminder for your interview.' )
    end
end

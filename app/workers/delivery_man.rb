class DeliveryMan
    include Sidekiq::Worker

    def perform(data,count)
        data = JSON.load(data)

        if data[:function]=='creation'
            InterviewMailer.create_mail(data[:send_to_email],data[:send_to_name],data[:topic],data[:date],data[:start],data[:finish],data[:interviewer],data[:candidate]).deliver_now
        elsif data[:function]=='update'
            InterviewMailer.update_mail(data[:send_to_email],data[:send_to_name],data[:topic],data[:date],data[:start],data[:finish],data[:interviewer],data[:candidate]).deliver_now
        elsif data[:function]=='reminder'
            InterviewMailer.reminder_mail(data[:send_to_email],data[:send_to_name]).deliver_now
        end
    end
end
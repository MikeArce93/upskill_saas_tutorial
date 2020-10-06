class ContactsController < ApplicationController
   
#GET request to /conact-us
#Show new contact form
    def new 
     @contact = Contact.new
    end
#Post request /contacts    
    def create
        #Mass assignement of form fields into Contact object
     @contact = Contact.new(contact_params)
        #save the contact object to database
        if @contact.save
        #Store form fields via parameters, into variables
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            #Plug variables into contact mailer
            #email method and send email
            ContactMailer.contact_email(name, email, body).deliver
            #store success message in flash hash
            #and redirect to new action
            flash[:success] = 'Message sent.'
         redirect_to new_contact_path_url
    else 
        #If Contact object doesnt save,
        #Store errors in flash hash
        #Then re-direct to the new action
            flash[:danger] = @contact.errors.full_messages.join(", ")
         redirect_to new_contact_path_url
        end
    end
    #To collect data from form
    #Use strong parameters and whitelist the form field
    private
        def contact_params 
            params.required(:contact).permit(:name, :email, :comments)
        end 
end
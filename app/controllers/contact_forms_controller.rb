class ContactFormsController < ApplicationController
skip_before_filter :authorize
    def new
      @contact_form = ContactForm.new
    end

    def create
      begin
        @contact_form = ContactForm.new(params[:contact_form])
        # @contact_form.request = request
		# Notifier.form_received(@contact_form).deliver
        if Notifier.form_received(@contact_form).deliver
          flash.now[:notice] = 'Thank you for your message!'
        else
          render :new
        end
      rescue ScriptError
        flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
      end
    end
	
	
	
  end

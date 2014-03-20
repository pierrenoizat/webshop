module ApplicationHelper

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display.none"
    end
    content_tag("div", attributes, &block)
  end
  
  
  
  def conv_rate
    
		@rate = Rate.last
	
    if time_condition
      @rate = Rate.create
      @rate.valeur = get_rate # find helper method get_rate in application_controller
      @rate.save
      end
      
	if @rate.valeur.nil?
	@rate.valeur = $DEFAULT_RATE
	$CONV_RATE = @rate.valeur
	@rate.save
	else
	$CONV_RATE = @rate.valeur
	end
	@rate.valeur = @rate.valeur
   end
	
	
	def time_condition
	temps = Time.now
	offset = 960  # 960 seconds = 16 minutes
	condition = :false
	rate = Rate.last
	condition = (( rate.created_at? and ( rate.created_at < ( temps - offset ))) and ( rate.updated_at? and ( rate.updated_at < (temps - offset))))
	condition
	end

end

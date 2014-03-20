class PagesController < ApplicationController
skip_before_filter :authorize
  def gallery
  end

  def faq
  
  @template = case I18n.locale.to_s
		when 'en' then '/pages/faq_en.html.erb'
		when 'fr' then '/pages/faq_fr.html.erb'
		else '/pages/faq_fr.html.erb'
		end
	render :template => @template
  
  end
  
    def shipping
  
  @template = case I18n.locale.to_s
		when 'en' then '/pages/shipping_en.html.erb'
		when 'fr' then '/pages/shipping_fr.html.erb'
		else '/pages/shipping_fr.html.erb'
		end
	render :template => @template
  
  end
  
  def coins
  
  @template = case I18n.locale.to_s
		when 'en' then '/pages/coins_en.html.erb'
		when 'fr' then '/pages/coins_fr.html.erb'
		else '/pages/coins_fr.html.erb'
		end
	render :template => @template
  
  end

  def news
  @template = case I18n.locale.to_s
		when 'en' then '/pages/news_en.html.erb'
		when 'fr' then '/pages/news_fr.html.erb'
		else '/pages/news_fr.html.erb'
		end
	render :template => @template
  end

  def cards
    
    @template = case I18n.locale.to_s
  		when 'en' then '/pages/cards_en.html.erb'
  		when 'fr' then '/pages/cards_fr.html.erb'
  		else '/pages/cards_fr.html.erb'
  		end
  	render :template => @template
    
  end

  def about
  @template = case I18n.locale.to_s
		when 'en' then '/pages/about_en.html.erb'
		when 'fr' then '/pages/about_fr.html.erb'
		else '/pages/about_fr.html.erb'
		end
	render :template => @template
  end
  
  def address
  @template = case I18n.locale.to_s
		when 'en' then '/pages/address_en.html.erb'
		when 'fr' then '/pages/address_fr.html.erb'
		else '/pages/address_fr.html.erb'
		end
	render :template => @template
  end

  def privacy
  end

  def tos
  end
  

end

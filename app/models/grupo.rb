class Grupo < ActiveRecord::Base
	include HTTParty

	validate :validar

	def validar
		if self.nombre.split.size > 1
				errors.add(:nombre, 'no debe tener espacios en blanco') 
		elsif self.nombre.blank?
			errors.add(:nombre, 'debe tener una palabra') 
		end
	end

	def graph
		graph = Koala::Facebook::GraphAPI.new
		begin
			#Todos los likes
			self.like = graph.get_object(self.nombre)["likes"]
			#Likes por Pais
			likesPais
			true
		rescue
			validar
			false
		end
	end

	def likesPais
		begin
			token = "CAACEdEose0cBAGcFpoSWzhTyqMmbpGM3ZCQ11oJZBkZAFAoKq8RqMaJeLzgdq2mCx9ZCkUB7QYWoRGs6WJLKqH1lBvVOgENbbDDAgTWGxMyrup2viRvR6PEXE3Wq85astj8d5K15BwYjZBCbOtmOH86ZA6ZBDWcMTndZC6iZAbUuhY4aUi3bIPo8wgHBrpFEAqsUyitm8vADpUjuCdavCAIYMxkr8jH1CmVYZD"
			response = HTTParty.get("https://graph.facebook.com/#{self.nombre}/insights/page_fans_country?access_token="+token, :query => {:oauth_token => token})
			json = JSON.parse(response.body)
			self.like_pais = json['data'][0]['values'][0]['value']['CL']
		rescue Exception => e
			self.like_pais = 0
		end
	end
end

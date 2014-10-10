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
			token = "CAACEdEose0cBANmotbcoA32N33hYVZBmqtnKvSKfLqgsHQpq28rmZBGhoX8lJMmf9vGyrzifdjAaybcjpeqXem9mmZBne7d2selwZBZCSFxf6Enw7l3qGpIJsZAnn6qr8nyA4piwbf98DFw1z2TewYxZCPR4HQ7kTivjBOzfyfsdThuZC7HC2ZAb2PTZAomVuHTwRaSECw7MbWDFX5gHSk9iZB55mJgXG8kl0cZD"
			response = HTTParty.get("https://graph.facebook.com/#{self.nombre}/insights/page_fans_country?access_token="+token, :query => {:oauth_token => token})
			json = JSON.parse(response.body)
			self.like_pais = json['data'][0]['values'][0]['value']['CL']
			true
		rescue Exception => e
			#token caduco
			self.like_pais = 0
		end
	end
end

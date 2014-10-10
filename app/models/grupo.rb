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
			token = "CAACEdEose0cBAJHfkzZCWQy4KbQBFDRwsgYpNgw8kEonCnWZBRi3R4Da3nEqCAu953kIrZCkaX1A7CvcTSQzZA1oYgwhM4zxluG2o3XnKTbZCoBwWY35dZALZCBmQcXKQqJQUexkUqAUAvdPct5mqr1PBtn5QnDOugJm7QhdLRj0s8Yx4CZBmeHAq6A5pgKPhgX7KU1USBz8ClBle3NPxiB3sb2HjuwhPgMZD"
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
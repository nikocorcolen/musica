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
			token = "CAACEdEose0cBACHeinfaSUzjeYmpnCa1B7dkZBbPwNFvr5KBrlZClbTBvT9RV6MD50wEt5lRnLPXvWvGFOgZAFXEpV45KSfMN9V3dOX2MiwKyWgONXOvhf4lVdC0BMuQuX9pI1Ce5shadtZCjAAZBRdKGucOhnfrfGbeFsPPOeaK1C2XjcCnCzANulXQnoaZAKi83FrbNZA0b3FpSklbPM2ZATNfTxQu2FcZD"
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
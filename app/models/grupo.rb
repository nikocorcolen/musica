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
			token = "CAACEdEose0cBAC5otM92lkwyr37NtBEKc0jnZBAZC7sjCdHmJ4P36ZBHTBKVz4TsfEHs3BaCxXDUBz1bmtBpIcEPODrOeHwYcEt9Hq73XuuoVEUdj3X4WpTxwlM9D0PcwqZA4hOOi5F5Y8Of9w0eZABoaXoZBRT8E2RzZAlGYNSiIr95NvZAqgeKivuAcmsjFj68YKad0DCbKxBSVO5iViwTUVznhCpn1JQZD"
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
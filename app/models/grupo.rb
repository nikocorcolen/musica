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
		token = "CAACEdEose0cBAOWAcsaPF0lQ6vS9h9JuOvPZA6hN6jwfiooZBfbNkOmK1RshE2SWYeHxETrmCdjarKdl51Y7EZAG75IywVRT14xLFqk0Cv2XNcpiSCAn7nucGZBVyyC6R8qqbubsfdZCqlghCZCSEHGVqTxZA0ZAFM9YlBkyeO41udetZBQhuKWC5D8QJpxZC251xd7X3VBImz7D9ZADn6p9zIqDdfKB50h3PUZD"
		graph = Koala::Facebook::GraphAPI.new
		begin
			#Todos los likes
			self.like = graph.get_object(self.nombre)["likes"]
			#Likes por Pais
			response = HTTParty.get("https://graph.facebook.com/#{self.nombre}/insights/page_fans_country?access_token="+token, :query => {:oauth_token => token})
			json = JSON.parse(response.body)
    		self.like_pais = json['data'][0]['values'][0]['value']['CL']
			true
		rescue
			validar
			false
		ensure
		end
	end
end

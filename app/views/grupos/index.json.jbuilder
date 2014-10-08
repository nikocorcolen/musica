json.array!(@grupos) do |grupo|
  json.extract! grupo, :id, :nombre, :like, :like_pais
  json.url grupo_url(grupo, format: :json)
end

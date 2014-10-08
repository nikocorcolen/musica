json.array!(@grupos) do |grupo|
  json.extract! grupo, :id, :nombre, :like
  json.url grupo_url(grupo, format: :json)
end

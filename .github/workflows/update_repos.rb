require 'net/http'
require 'json'
require 'yaml'

# Configuración
USERNAME = "lytsistemas" # Tu usuario de GitHub
EXCLUDED_REPO = "lytsistemas.github.io" # Repositorio a excluir
OUTPUT_FILE = "_data/repos.yml" # Archivo donde guardaremos los datos

# URL de la API de GitHub
url = URI("https://api.github.com/users/#{USERNAME}/repos?per_page=100&sort=updated")

# Petición a la API
response = Net::HTTP.get(url)
repos = JSON.parse(response)

# Filtrar y formatear los datos, excluyendo el repositorio definido
repos_data = repos.reject { |repo| repo["name"] == EXCLUDED_REPO }.map do |repo|
  {
    "name" => repo["name"],
    "description" => repo["description"],
    "url" => repo["html_url"],
    "stars" => repo["stargazers_count"],
    "language" => repo["language"],
    "updated_at" => repo["updated_at"]
  }
end

# Guardar en el archivo YAML
File.write(OUTPUT_FILE, { "repos" => repos_data }.to_yaml)

puts "✅ Repositorios actualizados en #{OUTPUT_FILE} (sin incluir '#{EXCLUDED_REPO}')"


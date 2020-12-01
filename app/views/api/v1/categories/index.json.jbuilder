json.categories do
  json.array! @categories, :id, :name
end

json.default_category do
  json.id @default_category&.id
  json.name @default_category&.name
end

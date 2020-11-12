json.list do
  json.merge! @usermylists.attributes
end

json.note do
  json.merge! @usernotes.attributes
end


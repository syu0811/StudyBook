json.array! @responses do |response|
  json.local_id response[:local_id]
  json.guid response[:guid]
  json.errors response[:errors]
  json.tag_errors response[:tag_errors]
end

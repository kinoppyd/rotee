json.extract! list, :id, :title, :body, :pointer, :cycle, :next_trigger_at, :created_at, :updated_at
json.url list_url(list, format: :json)

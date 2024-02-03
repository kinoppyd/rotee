module ListsHelper
  # Turbo frame tag for new item in list
  def new_item_id(list)
    "new_item_in_#{list.id}"
  end

  # Turbo frame tag for items in list
  def list_items_id(list)
    embed? ? "" : "list_items_#{list.id}"
  end

  # Turbo frame tag for list element wrapper
  def list_wrapper_id(list)
    "list_#{list.id}_wrapper"
  end

  def embed?
    request.path.start_with?('/embed')
  end
end

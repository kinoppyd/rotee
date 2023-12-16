require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
    @item = items(:one)
  end

  test "should get new" do
    get new_list_item_url(@list)
    assert_response :success
  end

  test "should create item" do
    assert_difference("Item.count") do
      post list_items_url(@list), params: { item: { list_id: @item.list_id, name: @item.name, position: @item.position } }
    end

    assert_redirected_to item_url(Item.order(created_at: :desc).first)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    patch item_url(@item), params: { item: { list_id: @item.list_id, name: @item.name, position: @item.position } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference("Item.count", -1) do
      delete item_url(@item)
    end

    assert_redirected_to list_url(@item.list)
  end
end

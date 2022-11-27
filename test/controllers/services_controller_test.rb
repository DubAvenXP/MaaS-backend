require "test_helper"

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
  end

  test "should get index" do
    get services_url, as: :json
    assert_response :success
  end

  test "should create service" do
    assert_difference("Service.count") do
      post services_url, params: { service: { client_id: @service.client_id, deleted_at: @service.deleted_at, description: @service.description, end_at: @service.end_at, name: @service.name, start_at: @service.start_at } }, as: :json
    end

    assert_response :created
  end

  test "should show service" do
    get service_url(@service), as: :json
    assert_response :success
  end

  test "should update service" do
    patch service_url(@service), params: { service: { client_id: @service.client_id, deleted_at: @service.deleted_at, description: @service.description, end_at: @service.end_at, name: @service.name, start_at: @service.start_at } }, as: :json
    assert_response :success
  end

  test "should destroy service" do
    assert_difference("Service.count", -1) do
      delete service_url(@service), as: :json
    end

    assert_response :no_content
  end
end

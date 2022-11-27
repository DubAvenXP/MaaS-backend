require "test_helper"

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @availability = availabilities(:one)
  end

  test "should get index" do
    get availabilities_url, as: :json
    assert_response :success
  end

  test "should create availability" do
    assert_difference("Availability.count") do
      post availabilities_url, params: { availability: { deleted_at: @availability.deleted_at, end_at: @availability.end_at, start_at: @availability.start_at, user_id: @availability.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show availability" do
    get availability_url(@availability), as: :json
    assert_response :success
  end

  test "should update availability" do
    patch availability_url(@availability), params: { availability: { deleted_at: @availability.deleted_at, end_at: @availability.end_at, start_at: @availability.start_at, user_id: @availability.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy availability" do
    assert_difference("Availability.count", -1) do
      delete availability_url(@availability), as: :json
    end

    assert_response :no_content
  end
end

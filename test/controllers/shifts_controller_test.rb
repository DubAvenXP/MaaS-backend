require "test_helper"

class ShiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shift = shifts(:one)
  end

  test "should get index" do
    get shifts_url, as: :json
    assert_response :success
  end

  test "should create shift" do
    assert_difference("Shift.count") do
      post shifts_url, params: { shift: { active: @shift.active, day: @shift.day, deleted_at: @shift.deleted_at, end_time: @shift.end_time, service_id: @shift.service_id, start_time: @shift.start_time } }, as: :json
    end

    assert_response :created
  end

  test "should show shift" do
    get shift_url(@shift), as: :json
    assert_response :success
  end

  test "should update shift" do
    patch shift_url(@shift), params: { shift: { active: @shift.active, day: @shift.day, deleted_at: @shift.deleted_at, end_time: @shift.end_time, service_id: @shift.service_id, start_time: @shift.start_time } }, as: :json
    assert_response :success
  end

  test "should destroy shift" do
    assert_difference("Shift.count", -1) do
      delete shift_url(@shift), as: :json
    end

    assert_response :no_content
  end
end

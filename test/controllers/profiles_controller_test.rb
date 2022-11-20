require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url, as: :json
    assert_response :success
  end

  test "should create profile" do
    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { deleted_at: @profile.deleted_at, first_name: @profile.first_name, last_name: @profile.last_name, phone: @profile.phone, picture: @profile.picture, role: @profile.role, user_id: @profile.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show profile" do
    get profile_url(@profile), as: :json
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { deleted_at: @profile.deleted_at, first_name: @profile.first_name, last_name: @profile.last_name, phone: @profile.phone, picture: @profile.picture, role: @profile.role, user_id: @profile.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@profile), as: :json
    end

    assert_response :no_content
  end
end

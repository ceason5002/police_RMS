require "test_helper"

class ArrestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @arrest = arrests(:one)
  end

  test "should get index" do
    get arrests_url
    assert_response :success
  end

  test "should get new" do
    get new_arrest_url
    assert_response :success
  end

  test "should create arrest" do
    assert_difference("Arrest.count") do
      post arrests_url, params: { arrest: { arrested_at: @arrest.arrested_at, charges: @arrest.charges, incident_id: @arrest.incident_id, person_id: @arrest.person_id } }
    end

    assert_redirected_to arrest_url(Arrest.last)
  end

  test "should show arrest" do
    get arrest_url(@arrest)
    assert_response :success
  end

  test "should get edit" do
    get edit_arrest_url(@arrest)
    assert_response :success
  end

  test "should update arrest" do
    patch arrest_url(@arrest), params: { arrest: { arrested_at: @arrest.arrested_at, charges: @arrest.charges, incident_id: @arrest.incident_id, person_id: @arrest.person_id } }
    assert_redirected_to arrest_url(@arrest)
  end

  test "should destroy arrest" do
    assert_difference("Arrest.count", -1) do
      delete arrest_url(@arrest)
    end

    assert_redirected_to arrests_url
  end
end

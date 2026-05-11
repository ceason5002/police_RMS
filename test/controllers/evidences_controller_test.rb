require "test_helper"

class EvidencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evidence = evidences(:one)
  end

  test "should get index" do
    get evidences_url
    assert_response :success
  end

  test "should get new" do
    get new_evidence_url
    assert_response :success
  end

  test "should create evidence" do
    assert_difference("Evidence.count") do
      post evidences_url, params: { evidence: { chain_of_custody: @evidence.chain_of_custody, collected_at: @evidence.collected_at, collected_by: @evidence.collected_by, description: @evidence.description, evidence_number: @evidence.evidence_number, incident_id: @evidence.incident_id, location_stored: @evidence.location_stored, status: @evidence.status } }
    end

    assert_redirected_to evidence_url(Evidence.last)
  end

  test "should show evidence" do
    get evidence_url(@evidence)
    assert_response :success
  end

  test "should get edit" do
    get edit_evidence_url(@evidence)
    assert_response :success
  end

  test "should update evidence" do
    patch evidence_url(@evidence), params: { evidence: { chain_of_custody: @evidence.chain_of_custody, collected_at: @evidence.collected_at, collected_by: @evidence.collected_by, description: @evidence.description, evidence_number: @evidence.evidence_number, incident_id: @evidence.incident_id, location_stored: @evidence.location_stored, status: @evidence.status } }
    assert_redirected_to evidence_url(@evidence)
  end

  test "should destroy evidence" do
    assert_difference("Evidence.count", -1) do
      delete evidence_url(@evidence)
    end

    assert_redirected_to evidences_url
  end
end

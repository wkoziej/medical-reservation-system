require 'test_helper'

class ExaminationKindsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:examination_kinds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create examination_kind" do
    assert_difference('ExaminationKind.count') do
      post :create, :examination_kind => { }
    end
    assert_redirected_to examination_kinds_path
  end

  test "should get edit" do
    get :edit, :id => examination_kinds(:one).id
    assert_response :success
  end

  test "should update examination_kind" do
    put :update, :id => examination_kinds(:one).id, :examination_kind => { }
    assert_redirected_to examination_kinds_path
  end

  test "should destroy examination_kind" do
    assert_difference('ExaminationKind.count', -1) do
      delete :destroy, :id => examination_kinds(:one).id
    end

    assert_redirected_to examination_kinds_path
  end
end

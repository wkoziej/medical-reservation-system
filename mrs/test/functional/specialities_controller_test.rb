require 'test_helper'

class SpecialitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:specialities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create speciality" do
    assert_difference('Speciality.count') do
      post :create, :speciality => { }
    end

    assert_redirected_to speciality_path(assigns(:speciality))
  end

  test "should show speciality" do
    get :show, :id => specialities(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => specialities(:one).id
    assert_response :success
  end

  test "should update speciality" do
    put :update, :id => specialities(:one).id, :speciality => { }
    assert_redirected_to speciality_path(assigns(:speciality))
  end

  test "should destroy speciality" do
    assert_difference('Speciality.count', -1) do
      delete :destroy, :id => specialities(:one).id
    end

    assert_redirected_to specialities_path
  end
end

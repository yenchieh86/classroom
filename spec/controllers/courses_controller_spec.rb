require 'rails_helper'

RSpec.describe CoursesController do
  describe "GET index" do
    it "assigns @courses and render" do
      course1 = create(:course)
      course2 = create(:course)
      
      get :index
      
      expect(assigns(:courses)).to eq([course1, course2])
      
    end
    
    it "render template" do
      course1 = create(:course)
      course2 = create(:course)
      
      get :index
      expect(response).to render_template('index')
    end
  end
  
  describe "GET show" do
    it "assigns @course and render" do
      course = create(:course)
      
      get :show, params: { id: course.id }
      
      expect(assigns(:course)).to eq(course)
    end
    
    it "renser template" do
      course = create(:course)
      
      get :show, params: { id: course.id }
      
      expect(response).to render_template("show")
    end
  end
  
  describe "GET new" do
    context "when user login" do
      let(:user) { create(:user) }
      let(:course) { build(:course) }
      
      before do
        sign_in user
        get :new
      end
      
      it "assign @course" do
        expect(assigns(:course)).to be_a_new(Course)
      end
      
      it "render template" do
        expect(response).to render_template("new")
      end
    end
    
    context "when user not login" do
      it "redirect_to new_user_session_path" do
        get :new
        
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  
  describe "POST create" do
    let(:user) {create(:user) }
    before { sign_in user }
    
    context "when @course doesn't have a title" do
      it "doesn't create a record" do
        expect do
          post :create, params: { course: { description: "boo" } }
        end.to change { Course.count }.by(0)
      end
      
      it "render new template" do
        post :create, params: { course: { description: "boo" } }
        
        expect(response).to render_template("new")
      end
    end
    
    context "when @course has title" do
      it "create a new course record" do
        course = build(:course)
        
        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change { Course.count }.by(1)
      end
      
      it "create a course for user" do
        course = build(:course)
        
        post :create, params: { course: attributes_for(:course) }
        
        expect(Course.last.user).to eq user
      end
      
      it "redirects to courses_path" do
        course = build(:course)
        
        post :create, params: { course: attributes_for(:course) }
        
        expect(response).to redirect_to courses_path
      end
    end
  end
  
  describe "GET edit" do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    
    context "signed in as author" do
      before { sign_in author }
      
      it "assign @course" do
        course = create(:course, user: author)
        
        get :edit, params: { id: course.id }
        
        expect(assigns(:course)).to eq course
      end
    
      it "render template" do
        course = create(:course, user: author)
        
        get :edit, params: { id: course.id }
        
        expect(response).to render_template("edit")
      end
    end
    
    context "signed in as not_author" do
      before { sign_in not_author }
      
      it "raises an error" do
        course = create(:course, user: author)
        
        expect do
          get :edit, params: { id: course.id }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
  describe "PUT update" do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    
    context "signed in as author" do
      before { sign_in author }
    
      context "when course has title" do
        it "assign @course" do
          course = create(:course, user: author)
          
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          
          expect(assigns(:course)).to eq course
        end
        
        it "change value" do
          course = create(:course, user: author)
          
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          
          expect(assigns(:course).title).to eq "Title"
          expect(assigns(:course).description).to eq "Description"
        end
        
        it "redirects to course_path" do
          course = create(:course, user: author)
          
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
          
          expect(response).to redirect_to course_path(course)
        end
      end
    
      context "when course doesn't have title" do
        it "doesn't update record" do
          course = create(:course, user: author)
          
          put :update, params: { id: course.id, course: { title: "", description: "Description" } }
          
          expect(assigns(:course).reload.description).not_to eq "Description"
        end
        
        it "renders edit template" do
          course = create(:course, user: author)
          
          put :update, params: { id: course.id, course: { title: "", description: "Description" } }
          
          expect(response).to render_template("edit")
        end
      end
    end
    
    context "signed in as not_author" do
      before { sign_in not_author }
      
      it "raises an error" do
        course = create(:course, user: author)
        
        expect do
          put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
  describe "DELETE destroy" do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    
    context "signed in as author" do
      before { sign_in author }
    
      it "assigns @course" do
        course = create(:course, user: author)
        
        delete :destroy, params: { id: course.id }
        
        expect(assigns(:course)).to eq course
      end
      
      it "deletes a record" do
        course = create(:course, user: author)
        
        expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
      end
      
      it "redirectes to courses_path" do
        course = create(:course, user: author)
        
        delete :destroy, params: { id: course.id }
        
        expect(response).to redirect_to courses_path
      end
    end
    
    context "signed in as not_author" do
      before { sign_in not_author }
      
      it "raises an error" do
        course = create(:course, user: author)
        
        expect do
          delete :destroy, params: { id: course.id }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
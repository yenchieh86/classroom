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
    it "assign @course" do
      course = build(:course)
      
      get :new
      
      expect(assigns(:course)).to be_a_new(Course)
    end
    
    it "render template" do
      course = build(:course)
      
      get :new
      
      expect(response).to render_template("new")
    end
  end
  
  describe "POST create" do
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
    
    context "when @course has a title" do
      it "create a new course record" do
        course = build(:course)
        
        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change { Course.count }.by(1)
      end
      
      it "redirects to courses_path" do
        course = build(:course)
        
        post :create, params: { course: attributes_for(:course) }
        
        expect(response).to redirect_to courses_path
      end
    end
  end
  
  describe "GET edit" do
    it "assign @course" do
      course = create(:course)
      
      get :edit, params: { id: course.id }
      
      expect(assigns(:course)).to eq course
    end
    
    it "render template" do
      course = create(:course)
      
      get :edit, params: { id: course.id }
      
      expect(response).to render_template("edit")
    end
  end
  
  describe "PUT update" do
    context "when course has title" do
      it "assign @course" do
        course = create(:course)
        
        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
        
        expect(assigns(:course)).to eq course
      end
      
      it "change value" do
        course = create(:course)
        
        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
        
        expect(assigns(:course).title).to eq "Title"
        expect(assigns(:course).description).to eq "Description"
      end
      
      it "redirects to course_path" do
        course = create(:course)
        
        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
        
        expect(response).to redirect_to course_path(course)
      end
    end
    
    context "when course doesn't have title" do
      it "doesn't update record" do
        course = create(:course)
        
        put :update, params: { id: course.id, course: { title: "", description: "Description" } }
        
        expect(assigns(:course).reload.description).not_to eq "Description"
      end
      
      it "renders edit template" do
        course = create(:course)
        
        put :update, params: { id: course.id, course: { title: "", description: "Description" } }
        
        expect(response).to render_template("edit")
      end
    end
  end
  
  describe "DELETE destroy" do
    it "assigns @course" do
      course = create(:course)
      
      delete :destroy, params: { id: course.id }
      
      expect(assigns(:course)).to eq course
    end
    
    it "deletes a record" do
      course = create(:course)
      
      expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
    end
    
    it "redirectes to courses_path" do
      course = create(:course)
      
      delete :destroy, params: { id: course.id }
      
      expect(response).to redirect_to courses_path
    end
  end
end
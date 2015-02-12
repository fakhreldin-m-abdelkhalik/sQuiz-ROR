require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::GroupsController, :type => :controller do
	
	before (:each) do
        @instructor = create(:instructor)
        @student = create(:student)
	end

	describe"create method succeeding"do
		it "create a new group for the current instructor" do
			sign_in @instructor
			post :create , group: {name: "g1"}
			group_response = json(response.body)
	     	expect(group_response[:name]).to eql("g1")	
	     	expect(group_response[:id]).to eql(1)     		
		end
	end

	describe"destroy method succeeding"do
		it "destroy a group for the current instructor" do
			sign_in @instructor
			post :create , group: {name: "g1"}
			# delete :destroy , {[id: 1]}
			group_response = json(response.body)
			expect(group_response[:info]).to eql("deleted")
		end
	end

	describe"add method succeeding"do
		it "adds student in a group by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :add ,student: {id: @student.id}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:success]).to eql(true)
			expect(group_response[:info]).to eql("Added")
		end
	end	

	describe"add method failing - no student"do
		it "adds student that does not exist in a group by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :add ,student: {id: 5}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:error]).to eql("Student does not exist")
		end
	end		

	describe"add method failing - no group"do
		it "adds student to a group that does not exist by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :add ,student: {id: @student.id}, group: {id: 5}
			group_response = json(response.body)
			expect(group_response[:error]).to eql("Group does not exist")
		end
	end		


	describe"add method failing -  student already exist"do
		it "adds student in a group  in which he already exists in by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :add ,student: {id: @student.id}, group: {id: @group.id}
			post :add ,student: {id: @student.id}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:error]).to eql("Student already exists in this group")
		end
	end	

	describe"remove method succeeding"do
		it "removes student from a group by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			@group.students << @student
			post :remove ,student: {id: @student.id}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:success]).to eql(true)
			expect(group_response[:info]).to eql("Removed")
		end
	end	

	describe"remove method failing - Student does not exist in this group"do
		it "removes student from a group in which it does not exist in by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :remove ,student: {id: @student.id}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:success]).to eql(false)
			expect(group_response[:info]).to eql("Student does not exist in this group")	
		end
	end		

	describe"remove method failing - Student does not exist"do
		it "removes student from a group by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			post :remove ,student: {id: 10}, group: {id: @group.id}
			group_response = json(response.body)
			expect(group_response[:success]).to eql(false)
			expect(group_response[:info]).to eql("Student does not exist")	
		end
	end		

	describe"remove method failing - Group does not exist"do
		it "removes student from a group by current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			@group.students << @student
			post :remove ,student: {id: @student.id}, group: {id: 10}
			group_response = json(response.body)
			expect(group_response[:success]).to eql(false)
			expect(group_response[:info]).to eql("Group does not exist")	
		end
	end		

	describe"instructor_index method succeeding"do
		it "returns groups for current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			get :instructor_index 
			group_response = json(response.body)
			expect((group_response).first[:name]).to eql(@group.name)
		end
	end	

	describe"student_index method succeeding"do
		it "returns groups for current student" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			sign_in @student
			@student.groups << @group
			get :student_index 
			group_response = json(response.body)
			expect(group_response[:success]).to eql(true)
			expect((group_response[:data][:groups]).first[:name]).to eql(@group.name)
		end
	end	

	describe"instructor_show method succeeding"do
		it "returns students in a group for a current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			@group.students << @student
			get :instructor_show ,id: @group.id
			group_response = json(response.body)
			expect((group_response).first[:name]).to eql(@student.name)
		end
	end

	describe"instructor_show method failing"do
		it "fails to return students in a group for a current instructor" do
			sign_in @instructor
			@group = create(:group)
			@instructor.groups << @group
			@group.students << @student
			get :instructor_show ,id: 4
			group_response = json(response.body)
			expect(group_response[:error]).to eql("group is not found")
		end
	end		

end
require 'spec_helper'

describe XCBuildFaster do
	describe XCBuildFaster::ProjectModifier do
		describe '#go!' do
			before(:each) do
				root_project_path = 'fixtures/FixtureProject/FixtureProject.xcodeproj'
				@project_modifier = XCBuildFaster::ProjectModifier.new(root_project_path, ignore_subprojects)
			end

			it 'should do things' do
				@project_modifier.go!
			end
		end
	end
end
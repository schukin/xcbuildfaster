require 'spec_helper'

describe XCBuildFaster do
	describe XCBuildFaster::ProjectModifier do
		describe '#go!' do
			before(:each) do
				root_project_path = '../twitter-ios/Twitter/Twitter.xcodeproj'
				ignore_subprojects = []
				@project_modifier = XCBuildFaster::ProjectModifier.new(root_project_path, ignore_subprojects)
			end

			it 'should do things' do
				@project_modifier.go!
			end
		end
	end
end
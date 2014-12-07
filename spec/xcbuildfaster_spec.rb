require 'spec_helper'

describe XCBuildFaster do
	describe XCBuildFaster::ProjectModifier do
		describe '#go!' do
			before(:each) do
				@root_project_path = 'fixtures/FixtureProject/FixtureProject.xcodeproj'
				project_modifier = XCBuildFaster::ProjectModifier.new(@root_project_path)
				project_modifier.go!
			end

			# This is a janky test but whatever
			it 'should disable the static analyzer' do
				static_analyzer_enabled_count = 0
				static_analyzer_disabled_count = 0
				project_file_lines = IO.readlines("#{@root_project_path}/project.pbxproj")

				project_file_lines.each_with_index do |line, index|
					if line.match(/RUN_CLANG_STATIC_ANALYZER/)
						next_line = project_file_lines[index + 1]
						if next_line.match(/YES/)
							static_analyzer_enabled_count += 1
						elsif next_line.match(/NO/)
							static_analyzer_disabled_count += 1
						end
					end
				end

				expect(static_analyzer_disabled_count).to eq(4)
				expect(static_analyzer_enabled_count).to eq(0)
			end
		end
	end
end
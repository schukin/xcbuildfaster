#!/usr/bin/env ruby

require 'xcbuildfaster'
require 'optparse'

ignore_subprojects = []

option_parser = OptionParser.new do |opts|
	opts.banner = "Usage: xcbuildfaster XCODE_PROJECT_PATH [options]"
	opts.on('-i', '--ignore SUBPROJECT_NAME', 'Ignore subproject') do |subproject_name|
		ignore_subprojects << subproject_name
	end
end

option_parser.parse!

if ARGV.empty?
	puts option_parser
	exit(-1)
end

root_project_path = ARGV.pop

project_modifier = XCBuildFaster::ProjectModifier.new(root_project_path, ignore_subprojects)
project_modifier.go!
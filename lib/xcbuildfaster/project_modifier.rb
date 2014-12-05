require "ext/xcodeproj"

module XCBuildFaster
	class ProjectModifier
		# root_project_path 
		def initialize(root_project_path, ignored_subprojects =[])
			@root_project = Xcodeproj::Project.open(root_project_path)
			@ignored_subprojects = ignored_subprojects
		end

		def go!
			puts "Modifying project: #{@root_project}"

			if @ignored_subprojects.count > 0
				puts "Ignoring subprojects: #{@ignored_subprojects}"
			end

			recursively_fastify(@root_project)

			puts "\nProject(s) successfully modified."
			puts "WARNING: Modified projects have had build phases removed & build settings changed. You probably don't want to commit any of these changes."
		end

		private
		def fastify(project)
			project.targets.each do |target|
				scripts = target.shell_script_build_phases
				target.shell_script_build_phases.each do |shell_script_build_phase|
					script = shell_script_build_phase.shell_script

					# Comment out each line of the script
					script = script.lines.map { |line| "# #{line}" }.join

					# Add a warning
					warning = "echo 'warning: #{target.to_s} modified by xcbuildfaster. Your run script(s) have been replaced with this warning, you probably dont want to commit this!'"
					script = "#{warning}\n#{script}"

					shell_script_build_phase.shell_script = script
				end

				target.build_configurations.each do |build_config|
					static_analysis_keys = ['RUN_CLANG_STATIC_ANALYZER',
						'CLANG_ANALYZER_DEADCODE_DEADSTORES', 
						'CLANG_ANALYZER_GCD', 
						'CLANG_ANALYZER_MEMORY_MANAGEMENT', 
						'CLANG_ANALYZER_OBJC_ATSYNC', 
						'CLANG_ANALYZER_OBJC_COLLECTIONS', 
						'CLANG_ANALYZER_OBJC_INCOMP_METHOD_TYPES', 
						'CLANG_ANALYZER_OBJC_NSCFERROR', 
						'CLANG_ANALYZER_OBJC_RETAIN_COUNT', 
						'CLANG_ANALYZER_OBJC_SELF_INIT', 
						'CLANG_ANALYZER_OBJC_UNUSED_IVARS',
						'CLANG_ANALYZER_SECURITY_INSECUREAPI_GETPW_GETS',
						'CLANG_ANALYZER_SECURITY_INSECUREAPI_MKSTEMP',
						'CLANG_ANALYZER_SECURITY_INSECUREAPI_UNCHECKEDRETURN',
						'CLANG_ANALYZER_SECURITY_INSECUREAPI_VFORK',
						'CLANG_ANALYZER_SECURITY_KEYCHAIN_API']

					static_analysis_keys.each do |key|
						build_config.build_settings[key] = 'NO'
					end

					# Don't generate dSYM files
					build_config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
				end
			end

			project.save
		end

		def recursively_fastify(project)
			if should_be_ignored?(project)
				puts "Ignoring: #{project}"
				return
			end

			fastify(project)
			puts "Successfully modified: #{project}"

			project.subprojects.each do |subproject|
				begin
					recursively_fastify(subproject)
				rescue
					puts "Could not recursively_fastify #{subproject}"
				end
			end
		end

		def should_be_ignored?(project)
			return @ignored_subprojects.any? { |ignored| project.to_s.include? ignored }
		end
	end
end
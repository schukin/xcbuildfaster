require "ext/xcodeproj"

module XCBuildFaster
	class ProjectModifier
		# root_project_path 
		def initialize(root_project_path, ignored_subprojects =[])
			@root_project = Xcodeproj::Project.open(root_project_path)
			@ignored_subprojects = ignored_subprojects
		end

		def go!
			recursively_fastify(@root_project)
		end

		private
		def fastify(project)
			project.targets.each do |target|
				scripts = target.shell_script_build_phases
				target.shell_script_build_phases.each do |shell_script_build_phase|
					shell_script_build_phase.shell_script = "# shell script removed. You probably don't want to commit this."
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
				return
			end

			fastify(project)
			puts "#{project} has been successfully modified"

			project.subprojects.each do |subproject|
				begin
					recursively_fastify(subproject)
				rescue
					puts "Could not recursively_fastify #{subproject}"
				end
			end
		end

		def should_be_ignored?(project)
			project_name = project.to_s
			return @ignored_subprojects.include? project_name
		end
	end
end
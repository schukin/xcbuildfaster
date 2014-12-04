require 'Xcodeproj'

class Xcodeproj::Project
	def subproject_refs
		subproject_refs = self.objects.select do |object|
			(object.is_a?(Xcodeproj::Project::Object::PBXFileReference) and object.to_s.downcase.include? 'xcodeproj')
		end

		return subproject_refs
	end

	def subprojects
		self.subproject_refs.map { |ref| Xcodeproj::Project.open(ref.real_path) }
	end
end
require 'xcodeproj'

project_name = 'SmartTask'
project_path = "#{project_name}.xcodeproj"
project = Xcodeproj::Project.new(project_path)

target = project.new_target(:application, project_name, :ios, '15.0')
target.build_configuration_list.set_setting('INFOPLIST_KEY_UIApplicationSceneManifest_Generation', 'YES')
target.build_configuration_list.set_setting('INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents', 'YES')
target.build_configuration_list.set_setting('INFOPLIST_KEY_UILaunchScreen_Generation', 'YES')
target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', 'com.antigravity.SmartTask')
target.build_configuration_list.set_setting('SWIFT_VERSION', '5.0')
target.build_configuration_list.set_setting('MARKETING_VERSION', '1.0')
target.build_configuration_list.set_setting('CURRENT_PROJECT_VERSION', '1')
target.build_configuration_list.set_setting('DEVELOPMENT_ASSET_PATHS', '"SmartTask/Preview Content"')
target.build_configuration_list.set_setting('ENABLE_PREVIEWS', 'YES')


main_group = project.main_group.new_group(project_name)

def add_files_to_group(project, target, group, dir_path)
  Dir.glob("#{dir_path}/*").each do |path|
    if File.directory?(path)
      subgroup = group.new_group(File.basename(path))
      add_files_to_group(project, target, subgroup, path)
    elsif path.end_with?('.swift')
      file_ref = group.new_file(path)
      target.add_file_references([file_ref])
    end
  end
end

add_files_to_group(project, target, main_group, 'SmartTask')

project.save
puts "Successfully created #{project_path}"

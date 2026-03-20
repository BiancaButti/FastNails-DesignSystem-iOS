require 'pathname'
require 'xcodeproj'

repo_root = Pathname.new(File.expand_path('..', __dir__))
catalog_demo_root = repo_root.join('CatalogDemo')
project_path = catalog_demo_root.join('CatalogDemo.xcodeproj')
ui_components_sources = repo_root.join('Sources', 'UIComponents')

project_path.rmtree if project_path.exist?

project = Xcodeproj::Project.new(project_path.to_s, false, 56)
project.root_object.attributes['LastSwiftUpdateCheck'] = '1600'
project.root_object.attributes['LastUpgradeCheck'] = '1600'
project.root_object.preferred_project_object_version = '56'

app_target = project.new_target(:application, 'CatalogDemo', :ios, '16.0')
app_target.product_name = 'CatalogDemo'

framework_target = project.new_target(:framework, 'UIComponents', :ios, '16.0')
framework_target.product_name = 'UIComponents'

app_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.fastnails.catalogdemo'
  config.build_settings['PRODUCT_NAME'] = 'CatalogDemo'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1'
  config.build_settings['SDKROOT'] = 'iphoneos'
  config.build_settings['INFOPLIST_KEY_UILaunchScreen_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UIApplicationSceneManifest_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents'] = 'YES'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
  config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
  config.build_settings['CODE_SIGN_IDENTITY'] = ''
    config.build_settings['MARKETING_VERSION'] = '1.0'
    config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
    config.build_settings['INFOPLIST_KEY_CFBundleShortVersionString'] = '$(MARKETING_VERSION)'
    config.build_settings['INFOPLIST_KEY_CFBundleVersion'] = '$(CURRENT_PROJECT_VERSION)'
end

framework_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.fastnails.uicomponents'
  config.build_settings['PRODUCT_NAME'] = 'UIComponents'
  config.build_settings['PRODUCT_MODULE_NAME'] = 'UIComponents'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1'
  config.build_settings['SDKROOT'] = 'iphoneos'
  config.build_settings['DEFINES_MODULE'] = 'YES'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['INFOPLIST_KEY_CFBundleShortVersionString'] = '$(MARKETING_VERSION)'
  config.build_settings['INFOPLIST_KEY_CFBundleVersion'] = '$(CURRENT_PROJECT_VERSION)'
  config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
  config.build_settings['SKIP_INSTALL'] = 'YES'
  config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
  config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
  config.build_settings['CODE_SIGN_IDENTITY'] = ''
end

main_group = project.main_group
catalog_group = main_group.find_subpath('CatalogDemo', true)
sources_group = catalog_group.find_subpath('Sources', true)
components_group = main_group.find_subpath('UIComponents', true)

catalog_sources = Dir[catalog_demo_root.join('Sources', '*.swift').to_s].sort
catalog_sources.each do |file|
  relative_path = Pathname.new(file).relative_path_from(project_path.parent).to_s
  file_ref = sources_group.new_file(relative_path)
  app_target.add_file_references([file_ref])
end

ui_component_files = Dir[ui_components_sources.join('*.swift').to_s]
  .reject { |path| File.basename(path).start_with?('.') }
  .sort

ui_component_files.each do |file|
  relative_path = Pathname.new(file).relative_path_from(project_path.parent).to_s
  file_ref = components_group.new_file(relative_path)
  framework_target.add_file_references([file_ref])
end

app_target.add_dependency(framework_target)
app_target.frameworks_build_phase.add_file_reference(framework_target.product_reference, true)

embed_frameworks_phase = app_target.new_copy_files_build_phase('Embed Frameworks')
embed_frameworks_phase.symbol_dst_subfolder_spec = :frameworks
embed_frameworks_phase.add_file_reference(framework_target.product_reference, true)

scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(app_target)
scheme.add_build_target(framework_target)
scheme.set_launch_target(app_target)
scheme.save_as(project_path, 'CatalogDemo', true)

project.save
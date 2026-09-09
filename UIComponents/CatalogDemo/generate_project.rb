require 'pathname'
require 'xcodeproj'

# Gera o app de catálogo consumindo o pacote UIComponents como dependência SwiftPM
# local. Isso garante que recursos e `Bundle.module` funcionem (o SwiftPM sintetiza
# esse acessor), ao contrário de compilar os fontes diretamente num framework.

catalog_demo_root = Pathname.new(File.expand_path(__dir__))
package_root = Pathname.new(File.expand_path('../..', __dir__)) # onde vive o Package.swift
project_path = catalog_demo_root.join('CatalogDemo.xcodeproj')

project_path.rmtree if project_path.exist?

project = Xcodeproj::Project.new(project_path.to_s, false, 56)
project.root_object.attributes['LastSwiftUpdateCheck'] = '1600'
project.root_object.attributes['LastUpgradeCheck'] = '1600'
project.root_object.preferred_project_object_version = '56'

app_target = project.new_target(:application, 'CatalogDemo', :ios, '16.0')
app_target.product_name = 'CatalogDemo'

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
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  # Team ID lido do ambiente para não versionar um identificador pessoal num repo público.
  # Defina antes de gerar, ex.: `DEVELOPMENT_TEAM=XXXXXXXXXX ruby generate_project.rb`
  config.build_settings['DEVELOPMENT_TEAM'] = ENV['DEVELOPMENT_TEAM'] || ''
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['INFOPLIST_KEY_CFBundleShortVersionString'] = '$(MARKETING_VERSION)'
  config.build_settings['INFOPLIST_KEY_CFBundleVersion'] = '$(CURRENT_PROJECT_VERSION)'
end

# Fontes do app de catálogo
main_group = project.main_group
catalog_group = main_group.find_subpath('CatalogDemo', true)
sources_group = catalog_group.find_subpath('Sources', true)

catalog_sources = Dir[catalog_demo_root.join('Sources', '*.swift').to_s].sort
catalog_sources.each do |file|
  relative_path = Pathname.new(file).relative_path_from(project_path.parent).to_s
  file_ref = sources_group.new_file(relative_path)
  app_target.add_file_references([file_ref])
end

# Dependência SwiftPM local para o pacote UIComponents
package_ref = project.new(Xcodeproj::Project::Object::XCLocalSwiftPackageReference)
package_ref.relative_path = package_root.relative_path_from(project_path.parent).to_s
project.root_object.package_references ||= []
project.root_object.package_references << package_ref

product_dep = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
product_dep.package = package_ref
product_dep.product_name = 'UIComponents'
app_target.package_product_dependencies << product_dep

build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
build_file.product_ref = product_dep
app_target.frameworks_build_phase.files << build_file

# Scheme executável
scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(app_target)
scheme.set_launch_target(app_target)
scheme.save_as(project_path, 'CatalogDemo', true)

project.save

# Workspace que junta o pacote (Package.swift) + o app.
# Abrir ESTE workspace (não o .xcodeproj) é o que garante a resolução do
# pacote local UIComponents e o funcionamento de Bundle.module.
workspace_path = catalog_demo_root.join('CatalogDemo.xcworkspace')
workspace_path.mkpath
package_rel = package_root.relative_path_from(catalog_demo_root).to_s
File.write(
  workspace_path.join('contents.xcworkspacedata'),
  <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <Workspace version="1.0">
       <FileRef location="group:#{package_rel}"></FileRef>
       <FileRef location="group:CatalogDemo.xcodeproj"></FileRef>
    </Workspace>
  XML
)

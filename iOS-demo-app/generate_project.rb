# frozen_string_literal: true

require "xcodeproj"

project_path = File.expand_path("SwiftExtrasiOSDemo.xcodeproj", __dir__)
project = Xcodeproj::Project.new(project_path)
project.root_object.attributes["LastSwiftUpdateCheck"] = "2700"
project.root_object.attributes["LastUpgradeCheck"] = "2700"

app_group = project.main_group.new_group("SwiftExtrasiOSDemo")
demo_group = app_group.new_group("Demo Sources", "../Tools/SwiftExtrasDemo")
app_source = app_group.new_file("SwiftExtrasiOSDemoApp.swift")

source_names = %w[
  ColorsAndImagesDemo.swift
  ContainersDemo.swift
  ControlsDemo.swift
  DemoCatalog.swift
  DemoComponents.swift
  LayoutsDemo.swift
  ModifiersDemo.swift
  OverviewDemo.swift
  PlatformDemo.swift
  StylesDemo.swift
  UtilitiesDemo.swift
]

target = project.new_target(
  :application,
  "SwiftExtrasiOSDemo",
  :ios,
  "17.0",
  nil,
  :swift
)

target.source_build_phase.add_file_reference(app_source)

source_names.each do |source_name|
  reference = demo_group.new_file(source_name)
  target.source_build_phase.add_file_reference(reference)
end

package_reference = project.new(
  Xcodeproj::Project::Object::XCLocalSwiftPackageReference
)
package_reference.relative_path = ".."
project.root_object.package_references << package_reference

package_product = project.new(
  Xcodeproj::Project::Object::XCSwiftPackageProductDependency
)
package_product.package = package_reference
package_product.product_name = "SwiftExtras"
target.package_product_dependencies << package_product

framework_build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
framework_build_file.product_ref = package_product
target.frameworks_build_phase.files << framework_build_file

target.build_configurations.each do |configuration|
  settings = configuration.build_settings
  settings["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS"] = "YES"
  settings["CODE_SIGN_STYLE"] = "Automatic"
  settings["CURRENT_PROJECT_VERSION"] = "1"
  settings["DEVELOPMENT_TEAM"] = ""
  settings["ENABLE_PREVIEWS"] = "YES"
  settings["GENERATE_INFOPLIST_FILE"] = "YES"
  settings["INFOPLIST_KEY_CFBundleDisplayName"] = "SwiftExtras Demo"
  settings["INFOPLIST_KEY_LSApplicationCategoryType"] = "public.app-category.developer-tools"
  settings["INFOPLIST_KEY_UIApplicationSceneManifest_Generation"] = "YES"
  settings["INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents"] = "YES"
  settings["INFOPLIST_KEY_UILaunchScreen_Generation"] = "YES"
  settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  settings["MARKETING_VERSION"] = "1.0"
  settings["PRODUCT_BUNDLE_IDENTIFIER"] = "nl.wesleydegroot.SwiftExtrasDemo"
  settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
  settings["SUPPORTED_PLATFORMS"] = "iphoneos iphonesimulator"
  settings["SUPPORTS_MACCATALYST"] = "NO"
  settings["SWIFT_EMIT_LOC_STRINGS"] = "YES"
  settings["SWIFT_VERSION"] = "5.0"
  settings["TARGETED_DEVICE_FAMILY"] = "1,2"
end

project.save

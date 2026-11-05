#!/usr/bin/env python3
"""Generate a dependency-free Xcode 15+ project. Stable IDs preserve local settings."""
import hashlib
from pathlib import Path
root = Path(__file__).resolve().parents[1]
def uid(value): return hashlib.sha256(value.encode()).hexdigest()[:24].upper()
def q(value): return '"' + str(value).replace('\\', '\\\\').replace('"', '\\"') + '"'
objects = []
def add(key, text): objects.append(f'\t\t{uid(key)} = {{ {text} }};')
app_sources = sorted(p for p in (root / 'BusinessClicker').rglob('*.swift') if 'Tests' not in p.parts and 'UITests' not in p.parts)
unit_sources = sorted((root / 'BusinessClicker/Tests').rglob('*.swift'))
ui_sources = sorted((root / 'BusinessClicker/UITests').rglob('*.swift'))
resources = sorted(p for p in (root / 'BusinessClicker/Resources').iterdir() if p.name == 'Kenney' or p.suffix in ['.wav', '.xcassets', '.xcprivacy', '.png', '.jpg', '.json'])
all_files = app_sources + unit_sources + ui_sources + resources
for p in all_files:
    path = p.relative_to(root).as_posix()
    kind = {'swift': 'sourcecode.swift', 'wav': 'audio.wav', 'xcassets': 'folder.assetcatalog', 'xcprivacy': 'text.xml', 'png': 'image.png', 'jpg': 'image.jpeg', 'json': 'text.json', '': 'folder'}[p.suffix[1:]]
    add(path, f'isa = PBXFileReference; lastKnownFileType = {kind}; path = {q(path)}; sourceTree = SOURCE_ROOT;')
    add(path + '-build', f'isa = PBXBuildFile; fileRef = {uid(path)};')
products = [('app', 'BusinessClicker.app', 'wrapper.application'), ('unit', 'BusinessClickerTests.xctest', 'wrapper.cfbundle'), ('ui', 'BusinessClickerUITests.xctest', 'wrapper.cfbundle')]
for key, name, kind in products: add(key + '-product', f'isa = PBXFileReference; explicitFileType = {kind}; path = {name}; sourceTree = BUILT_PRODUCTS_DIR;')
add('main-group', 'isa = PBXGroup; children = (' + ','.join(uid(p.relative_to(root).as_posix()) for p in all_files) + ',' + uid('products') + '); sourceTree = "<group>";')
add('products', 'isa = PBXGroup; children = (' + ','.join(uid(key + '-product') for key, _, _ in products) + '); name = Products; sourceTree = "<group>";')
for target, name, sources in [('app', 'BusinessClicker', app_sources), ('unit', 'BusinessClickerTests', unit_sources), ('ui', 'BusinessClickerUITests', ui_sources)]:
    add(target + '-sources', 'isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (' + ','.join(uid(p.relative_to(root).as_posix() + '-build') for p in sources) + '); runOnlyForDeploymentPostprocessing = 0;')
    add(target + '-resources', 'isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (' + (','.join(uid(p.relative_to(root).as_posix() + '-build') for p in resources) if target == 'app' else '') + '); runOnlyForDeploymentPostprocessing = 0;')
    add(target + '-frameworks', 'isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0;')
    if target != 'app':
        add(target + '-proxy', f'isa = PBXContainerItemProxy; containerPortal = {uid("project")}; proxyType = 1; remoteGlobalIDString = {uid("app-target")}; remoteInfo = BusinessClicker;')
        add(target + '-dependency', f'isa = PBXTargetDependency; target = {uid("app-target")}; targetProxy = {uid(target + "-proxy")};')
    product_type = {'app': 'application', 'unit': 'bundle.unit-test', 'ui': 'bundle.ui-testing'}[target]
    deps = '' if target == 'app' else uid(target + '-dependency')
    add(target + '-target', f'isa = PBXNativeTarget; buildConfigurationList = {uid(target + "-configs")}; buildPhases = ({uid(target + "-sources")},{uid(target + "-frameworks")},{uid(target + "-resources")}); buildRules = (); dependencies = ({deps}); name = {name}; productName = {name}; productReference = {uid(target + "-product")}; productType = "com.apple.product-type.{product_type}";')
    for config in ['Debug', 'Release']:
        settings = {
            'PRODUCT_NAME': '$(TARGET_NAME)', 'PRODUCT_BUNDLE_IDENTIFIER': 'com.businessclicker.' + name.lower(),
            'SWIFT_VERSION': '5.0', 'IPHONEOS_DEPLOYMENT_TARGET': '17.0', 'TARGETED_DEVICE_FAMILY': '1',
            'GENERATE_INFOPLIST_FILE': 'YES', 'CODE_SIGN_STYLE': 'Automatic', 'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator',
            'SWIFT_EMIT_LOC_STRINGS': 'YES', 'SWIFT_OPTIMIZATION_LEVEL': '-Onone' if config == 'Debug' else '-O',
            'LD_RUNPATH_SEARCH_PATHS': '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
        }
        if target == 'app':
            settings.update({'INFOPLIST_KEY_CFBundleDisplayName': 'Business Clicker', 'INFOPLIST_KEY_UILaunchScreen_Generation': 'YES', 'INFOPLIST_KEY_UIApplicationSceneManifest_Generation': 'YES', 'INFOPLIST_KEY_UISupportedInterfaceOrientations': 'UIInterfaceOrientationPortrait', 'ASSETCATALOG_COMPILER_APPICON_NAME': 'AppIcon', 'ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME': 'AccentColor', 'MARKETING_VERSION': '1.2', 'CURRENT_PROJECT_VERSION': '1', 'ENABLE_TESTABILITY': 'YES' if config == 'Debug' else 'NO', 'INFOPLIST_KEY_ITSAppUsesNonExemptEncryption': 'NO'})
        elif target == 'unit': settings.update({'BUNDLE_LOADER': '$(TEST_HOST)', 'TEST_HOST': '$(BUILT_PRODUCTS_DIR)/BusinessClicker.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/BusinessClicker'})
        else: settings['TEST_TARGET_NAME'] = 'BusinessClicker'
        add(target + '-' + config, 'isa = XCBuildConfiguration; buildSettings = {' + ''.join(f'{k} = {q(v)};' for k, v in settings.items()) + f'}}; name = {config};')
    add(target + '-configs', f'isa = XCConfigurationList; buildConfigurations = ({uid(target + "-Debug")},{uid(target + "-Release")}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release;')
for config in ['Debug', 'Release']:
    add('project-' + config, 'isa = XCBuildConfiguration; buildSettings = {CLANG_ENABLE_MODULES = YES; SDKROOT = iphoneos; SWIFT_STRICT_CONCURRENCY = targeted; GCC_C_LANGUAGE_STANDARD = gnu17; DEBUG_INFORMATION_FORMAT = ' + ('dwarf' if config == 'Debug' else '"dwarf-with-dsym"') + '; SWIFT_ACTIVE_COMPILATION_CONDITIONS = ' + ('DEBUG' if config == 'Debug' else '""') + f';}}; name = {config};')
add('project-configs', f'isa = XCConfigurationList; buildConfigurations = ({uid("project-Debug")},{uid("project-Release")}); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release;')
add('project', f'isa = PBXProject; attributes = {{ BuildIndependentTargetsInParallel = YES; LastUpgradeCheck = 1600; TargetAttributes = {{ {uid("app-target")} = {{CreatedOnToolsVersion = 16.0;}}; {uid("unit-target")} = {{CreatedOnToolsVersion = 16.0; TestTargetID = {uid("app-target")};}}; {uid("ui-target")} = {{CreatedOnToolsVersion = 16.0; TestTargetID = {uid("app-target")};}}; }}; }}; buildConfigurationList = {uid("project-configs")}; compatibilityVersion = "Xcode 14.0"; developmentRegion = fr; hasScannedForEncodings = 0; knownRegions = (fr,en,Base); mainGroup = {uid("main-group")}; productRefGroup = {uid("products")}; projectDirPath = ""; projectRoot = ""; targets = ({uid("app-target")},{uid("unit-target")},{uid("ui-target")});')
project_dir = root / 'BusinessClicker.xcodeproj'
project_dir.mkdir(exist_ok=True)
(project_dir / 'project.pbxproj').write_text('// !$*UTF8*$!\n{\n\tarchiveVersion = 1;\n\tclasses = {};\n\tobjectVersion = 56;\n\tobjects = {\n' + '\n'.join(objects) + '\n\t};\n\trootObject = ' + uid('project') + ';\n}\n')
scheme_dir = project_dir / 'xcshareddata/xcschemes'; scheme_dir.mkdir(parents=True, exist_ok=True)
def ref(key, name): return f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{uid(key + "-target")}" BuildableName="{name}" BlueprintName="{name.split(".")[0]}" ReferencedContainer="container:BusinessClicker.xcodeproj"/>'
app = ref('app', 'BusinessClicker.app')
(scheme_dir / 'BusinessClicker.xcscheme').write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="1600" version="1.3">
<BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES"><BuildActionEntries><BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{app}</BuildActionEntry></BuildActionEntries></BuildAction>
<TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES"><Testables><TestableReference skipped="NO">{ref('unit', 'BusinessClickerTests.xctest')}</TestableReference><TestableReference skipped="NO">{ref('ui', 'BusinessClickerUITests.xctest')}</TestableReference></Testables></TestAction>
<LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></LaunchAction>
<ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app}</BuildableProductRunnable></ProfileAction>
<AnalyzeAction buildConfiguration="Debug"/><ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>''')
print(f'Generated Xcode project: {len(app_sources)} app sources, {len(unit_sources)} unit sources, {len(resources)} resources.')

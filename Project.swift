import ProjectDescription
import ProjectDescriptionHelpers

let appName = ProjectConstants.appName

let project = Project(
    name: appName,
    settings: .settings(base: BuildFlags.base),
    targets: [
        Targets.appTarget
    ]
)

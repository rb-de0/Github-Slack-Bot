import PackageDescription

let package = Package(
    name: "Github-Slack-Bot",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 4),
        .Package(url: "https://github.com/pvzig/SlackKit.git", majorVersion: 3),
        .Package(url: "https://github.com/ikesyo/Himotoki.git", majorVersion: 3)
    ]
)

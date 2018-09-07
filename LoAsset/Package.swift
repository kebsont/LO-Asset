import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .Package(url: "https://github.com/Nero5023/CSVParser",
                 majorVersion: 1),
        ]
)

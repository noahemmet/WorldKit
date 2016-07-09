import PackageDescription

let package = Package(
    name: "WorldKit",
    dependencies: [
        .Package(url: "https://github.com/noahemmet/Grid.git", 
                      Version(0,0,5)
        )
    ]
)

def flutterRoot = settings.rootDir.parentFile

def plugins = new Properties()
def pluginsFile = new File(flutterRoot, '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterRoot.toPath().resolve(path).toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory
}

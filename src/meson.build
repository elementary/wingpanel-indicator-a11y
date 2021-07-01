wingpanel_dep = dependency('wingpanel')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

files = files(
    'Indicator.vala',
    'SessionWidget.vala',
)

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
    meson.get_compiler('vala').find_library('posix'),
    wingpanel_dep
]

shared_module(
    meson.project_name(),
    files,
    dependencies: dependencies,
    install: true,
    install_dir : wingpanel_indicatorsdir
)

wingpanel_dep = dependency('wingpanel', version: '>=4.0.0')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

files = files(
    # 'GreeterWidget.vala',
    'Indicator.vala',
    'SessionWidget.vala',
)

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('granite-7'),
    dependency('gtk4'),
    meson.get_compiler('vala').find_library('posix'),
    wingpanel_dep
]

shared_module(
    meson.project_name(),
    files,
    config_file,
    dependencies: dependencies,
    install: true,
    install_dir : wingpanel_indicatorsdir
)

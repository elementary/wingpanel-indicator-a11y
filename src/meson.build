wingpanel_dep = dependency('wingpanel-2.0')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

conf_data = configuration_data()
conf_data.set('GETTEXT_PACKAGE', gettext_name)

config_in = configure_file(
    input: 'config.vala.in',
    output: '@BASENAME@',
    configuration: conf_data
)

files = files(
    'GreeterWidget.vala',
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
    config_in,
    dependencies: dependencies,
    install: true,
    install_dir : wingpanel_indicatorsdir
)

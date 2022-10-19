project(
    'a11y',
    'vala', 'c',
    version: '1.0.1'
)

gettext_name = meson.project_name() + '-indicator'
i18n = import('i18n')

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')
add_project_arguments('-DG_LOG_DOMAIN="io.elementary.wingpanel.a11y"', language:'c')

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name() + '-indicator')
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script(join_paths('meson', 'post_install.py'))

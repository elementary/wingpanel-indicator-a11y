project(
    'a11y',
    'vala', 'c',
    version: '1.0.0'
)

gettext_name = meson.project_name() + '-indicator'
i18n = import('i18n')

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script(join_paths('meson', 'post_install.py'))

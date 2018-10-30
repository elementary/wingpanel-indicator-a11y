project(
    'a11y',
    'vala', 'c',
    version: '1.0.0'
)

gettext_name = meson.project_name() + '-indicator'
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

subdir('po')
subdir('src')


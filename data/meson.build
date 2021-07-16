install_data(
    'io.elementary.desktop.wingpanel.a11y.gschema.xml',
    install_dir: join_paths(datadir, 'glib-2.0', 'schemas')
)

i18n.merge_file(
    input: 'a11y.appdata.xml.in',
    output: 'io.elementary.wingpanel.a11y.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po', 'extra'),
    type: 'xml',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
)

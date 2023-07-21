install_data(
    'io.elementary.desktop.wingpanel.a11y.gschema.xml',
    install_dir: join_paths(datadir, 'glib-2.0', 'schemas')
)

i18n.merge_file(
    input: 'a11y.metainfo.xml.in',
    output: 'io.elementary.wingpanel.a11y.metainfo.xml',
    po_dir: meson.source_root() / 'po' / 'extra',
    type: 'xml',
    install: true,
    install_dir: get_option('datadir') / 'metainfo',
)

plug_files = files(
    'Plug.vala',
    'Widgets/Sidebar.vala',
    'Widgets/SettingsOption.vala',
    'Widgets/MainView.vala',
    'Widgets/AppSettingsView.vala',
    'Widgets/AppEntry.vala',
    'Backend/NotifyManager.vala',
    'Backend/App.vala'
)

switchboard_dep = dependency('switchboard-3')
switchboard_plugsdir = switchboard_dep.get_pkgconfig_variable('plugsdir', define_variable: ['libdir', libdir])

shared_module(
    meson.project_name(),
    plug_files,
    config_file,
    plug_resources,
    dependencies: [
        adw_dep,
        dependency('glib-2.0'),
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('granite-7'),
        dependency('gtk4'),
        switchboard_dep
    ],
    install: true,
    install_dir : join_paths(switchboard_plugsdir, 'personal')
)

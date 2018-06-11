project(
    'notifications',
    'vala', 'c',
    version: '0.1.4'
)

gettext_name = meson.project_name() + '-plug'
gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

plug_resources = gnome.compile_resources(
    'plug_resources',
    'data/switchboard-plug-notifications.gresource.xml',
    source_dir: 'data'
)

subdir('data')
subdir('src')
subdir('po')

fx_version 'cerulean'
games { 'gta5' }
author 'thedoc'

ui_page 'ui/html/menu.html'

files {
    'ui/**'
}

client_scripts {
    'client/**',
    'utils/utils.lua'
}

server_scripts {
    'server/**'
}

shared_scripts {
    'config.lua'
}

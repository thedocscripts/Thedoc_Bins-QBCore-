fx_version 'cerulean'
games {'gta5'}
author 'thedoc'

shared_script 'config.lua'
client_script 'client/client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

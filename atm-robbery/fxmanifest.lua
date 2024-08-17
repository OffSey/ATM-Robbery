fx_version 'bodacious'
games {'gta5'}
version '1.0.2'
lua54 'yes'
author 'OffSey'
description 'Robbery ATM'
discord 'https://discord.gg/SWDSeKksaR'

files {
    'locales/*.json'
}

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/cl_editable.lua',
    'client/cl_main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_version.lua',
    'server/bridge/*.lua',
    'server/sv_main.lua',
}

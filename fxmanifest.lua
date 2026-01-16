fx_version 'cerulean'
game 'gta5'

Author 'bndev & manimods'
Description 'Library for bndev and manimods resources'
Version '1.0.0'


shared_scripts {
    '@ox_lib/init.lua',
    'init.lua',
}

files {
    'init.lua',
    'modules/**/*.lua',
    'modules/**/*.lua',
    'modules/**/*.lua',
}

client_scripts {
    'client.lua',
    'resource/client/*.lua',
}

server_scripts {
    'server.lua',
    'resource/server/*.lua',
}


lua54 'yes'


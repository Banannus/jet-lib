fx_version 'cerulean'
game 'gta5'

Author 'bndev & manimods'
Description 'Library for bndev and manimods resources'
Version '1.0.0'

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

files {
    'modules/**/*.lua',
    'modules/**/*.lua',
    'modules/**/*.lua',
}

shared_scripts {
    'dependencies.lua',
    'init.lua',
    '@ox_lib/init.lua',
} 

lua54 'yes'


fx_version 'cerulean'
game 'gta5'

Author 'bndev & manimods'
Description 'Library for bndev and manimods resources'
Version '1.0.0'

lua54 'yes'

-- ui_page 'http://localhost:5173/'
ui_page 'web/build/index.html'

shared_scripts {
    'dependencies.lua',
    'resource/init.lua',
    'resource/**/shared.lua',
}

files {
    'init.lua',
    'modules/**/client.lua',
    'modules/**/shared.lua',
    'modules/**/client_*.lua',
    'web/build/index.html',
    'web/build/**/*'
}

client_scripts {
    'resource/**/client.lua'
}

server_scripts {
    'resource/**/server.lua'
}
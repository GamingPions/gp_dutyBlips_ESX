fx_version 'bodacious'
game 'gta5'

name 'gp_dutyBlips'
description 'Color Blips depending on onduty members'

version '1.0.0'

author 'gpScript / Gamingpions <store@gp-resources.net>'
lua54 'yes'

shared_scripts {
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'shared_functions.lua',
  'config.lua',
}

client_scripts {
  'client/cl_main.lua',
}

server_scripts {
  'server/*.lua',
}

escrow_ignore {
  'config.lua',
  'shared_functions.lua',
  'client/*.lua',
}

package = 'lua-hdf5'
version = '0-0'

source = {url = ''}
description = {
    summary = 'HDF5',
    detailed = '',
    homepage = '',
    license = 'MIT/X11'
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = 'builtin',
    modules = {
        HDF5 = 'lua-hdf5.c',
        buffer = 'buffer.c'
    }
}


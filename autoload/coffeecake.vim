"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/coffee-cake.vim
"VERSION:  0.1
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

let g:coffee_cake_plugindir = expand('<sfile>:p:h:h').'/'
let g:coffee_cake_templatedir = g:coffee_cake_plugindir.'template/'
let g:coffee_cake_stoptext = '// coffee-cake stopped.'

if !exists("g:coffee_cake_cdloop")
    let g:coffee_cake_cdloop = 5
endif
if !exists("g:coffee_cake_makefile")
    let g:coffee_cake_makefile = 'grunt.js'
endif
if !exists("g:coffee_cake_cmd")
    let g:coffee_cake_cmd = 'grunt&'
endif
if !exists("g:coffee_cake_manural_cmd")
    let g:coffee_cake_manural_cmd = 'grunt'
endif
if !exists("g:coffee_cake_makefiledir")
    let g:coffee_cake_makefiledir = $HOME.'/.coffeecake/'
endif

if !isdirectory(g:coffee_cake_makefiledir)
    call mkdir(g:coffee_cake_makefiledir)
    call system('cp '.g:coffee_cake_templatedir.'* '.g:coffee_cake_makefiledir)
endif

function! coffeecake#Stop()
    let dir = coffeecake#Search()
    let filename = dir.g:coffee_cake_makefile

    let makefile = readfile(filename)

    if makefile[0] != g:coffee_cake_stoptext
        let makefile = insert(makefile, g:coffee_cake_stoptext)
        call writefile(makefile, filename)
    endif
endfunction

function! coffeecake#Play()
    let dir = coffeecake#Search()
    let filename = dir.g:coffee_cake_makefile

    let makefile = readfile(filename)

    if makefile[0] == g:coffee_cake_stoptext
        call remove(makefile, 0)
        call writefile(makefile, filename)
    endif
endfunction

function! coffeecake#Pause()
    let g:coffee_cake_pause = 1
endfunction

function! coffeecake#Resume()
    let g:coffee_cake_pause = 0
endfunction

function! coffeecake#Search()
    let i = 0
    let dir = expand('%:p:h').'/'
    while i < g:coffee_cake_cdloop
        if !filereadable(dir.g:coffee_cake_makefile)
            let i = i + 1
            let dir = dir.'../'
        else
            break
        endif
    endwhile

    if i != g:coffee_cake_cdloop
        return dir
    endif
    return ''
endfunction

function! coffeecake#Search()
    let i = 0
    let dir = expand('%:p:h').'/'
    while i < g:coffee_cake_cdloop
        if !filereadable(dir.g:coffee_cake_makefile)
            let i = i + 1
            let dir = dir.'../'
        else
            break
        endif
    endwhile

    if i != g:coffee_cake_cdloop
        return dir
    endif
    return ''
endfunction

function! coffeecake#Default()
    let dir = coffeecake#Search()
    if dir != '' && g:coffee_cake_pause == 0
        let org = getcwd()
        exec 'silent cd '.dir

        let makefile = readfile(g:coffee_cake_makefile)
        if makefile[0] != g:coffee_cake_stoptext
            silent call system(g:coffee_cake_cmd)
        endif

        exec 'silent cd '.org
    endif

endfunction

function! coffeecake#ManualDefault()
    let dir = coffeecake#Search()
    if dir != ''
        let org = getcwd()
        exec 'silent cd '.dir
        let er = system(g:coffee_cake_manural_cmd)
        exec 'silent cd '.org

        if er != ''
            setlocal errorformat=%f:%l:%m
            cgetexpr er
            copen
        else
            copen
        endif
    endif
endfunction

function! coffeecake#Edit()
    let dir = coffeecake#Search()
    if dir != ''
        exec 'e '.dir.g:coffee_cake_makefile
    endif
endfunction

function! coffeecake#Template()
    if !filereadable(g:coffee_cake_makefiledir.g:coffee_cake_makefile)
        let org = getcwd()
        exec 'cd '.g:coffee_cake_makefiledir
        call writefile([], g:coffee_cake_makefile)
        exec 'cd '.org
    endif

    exec 'e '.g:coffee_cake_makefiledir.g:coffee_cake_makefile
endfunction

function! coffeecake#Create()
    if !filereadable(g:coffee_cake_makefile)
        if filereadable(g:coffee_cake_makefiledir.g:coffee_cake_makefile)
            call writefile(readfile(g:coffee_cake_makefiledir.g:coffee_cake_makefile), g:coffee_cake_makefile)
        else
            call writefile([], g:coffee_cake_makefile)
        endif
        exec 'e '.g:coffee_cake_makefile
    endif
endfunction

let &cpo = s:save_cpo

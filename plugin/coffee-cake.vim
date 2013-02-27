"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/coffee-cake.vim
"VERSION:  0.1
"LICENSE:  MIT

if exists("g:loaded_coffee_cake")
    finish
endif
let g:loaded_coffee_cake = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:coffee_cake_file")
    let g:coffee_cake_file = []
endif
if !exists("g:coffee_cake_update_ext")
    let g:coffee_cake_update_ext = ''
endif
if !exists("g:coffee_cake_pause")
    let g:coffee_cake_pause = 0
endif

command! CoffeeDefault call coffeecake#ManualDefault()
command! CoffeeEdit call coffeecake#Edit()
command! CoffeeCreate call coffeecake#Create()
command! CoffeeTemplate call coffeecake#Template()
command! CoffeePause call coffeecake#Pause()
command! CoffeeResume call coffeecake#Resume()
command! CoffeeStop call coffeecake#Stop()
command! CoffeePlay call coffeecake#Play()

function! s:SetAutoCmd(files)
    if type(a:files) != 3
        let file = [a:files]
    else
        let file = a:files
    endif

    if file != []
        for e in file
            exec 'au BufWritePost *.'.e.' call coffeecake#Default()'
        endfor
    endif
    unlet file
endfunction
au VimEnter * call s:SetAutoCmd(g:coffee_cake_file)

let &cpo = s:save_cpo
unlet s:save_cpo

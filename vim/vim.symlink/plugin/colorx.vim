""" Author: Maximilian Nickel
""" Version: 0.2
""" License: http://www.opensource.org/licenses/bsd-license.php

" Description: {{{
" 	This plugin opens the Mac OS X color picker and inserts
" 	the choosen color at the current position.
" 	Either Hex values or raw RGB values are supported
" }}}

" Don't load script when already loaded
" or when not on Mac
if exists("g:loaded_colorchooser") || !has('mac')
	finish
endif
let g:loaded_colorchooser = 1

let s:app = 'Terminal.app'
if has('gui_macvim')
	let s:app = 'MacVim.app'
endif

let s:ascrpt = ['-e "tell application \"' . s:app . '\""', 
			\ '-e "activate"', 
			\ "-e \"set AppleScript's text item delimiters to {\\\",\\\"}\"",
			\ '-e "set col to (choose color) as text"',
			\ '-e "end tell"']

function! s:colour_rgb()
	return system("osascript " . join(s:ascrpt, ' '))
endfunction

function! s:append_colour(col)
	exe "normal a" . a:col
endfunction

function! s:colour_hex()
	let rgb = split(s:colour_rgb(), ',')
	return printf('#%02X%02X%02X', str2nr(rgb[0])/256, str2nr(rgb[1])/256, str2nr(rgb[2])/256)
endfunction

command! ColorRGB :call s:append_colour(s:colour_rgb())
command! ColorHEX :call s:append_colour(s:colour_hex())

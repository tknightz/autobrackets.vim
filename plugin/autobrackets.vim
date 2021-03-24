if exists('g:autobrackets_loaded')
    finish
endif

let g:autobrackets_loaded = 1


function! s:GetNextChar()
  return getline('.')[col('.') - 1]
endfunction

function! s:GetPreChar()
  return getline('.')[col('.') - 2]
endfunction

function! s:MatchBrackets(sign)
  if a:sign == "'"
    return "'"
  elseif a:sign == "("
    return ")"
  elseif a:sign == "["
    return "]"
  elseif a:sign == "{"
    return "}"
  elseif a:sign == '"'
    return '"'
  else
    return -1
  endif
endfunction

function! AutoCloseBrackets(sign)
  let next_char = s:GetNextChar()
  let close_char = s:MatchBrackets(a:sign)

  if next_char == a:sign
    return "\<right>"
  else
    if close_char != -1
      return a:sign.close_char."\<esc>ha"
    else
      return a:sign
  endif
endfunction

function! s:IsInsideBracket()
  let pre_char = s:GetPreChar()
  let next_char = s:GetNextChar()
  let close_char = s:MatchBrackets(pre_char)
  if close_char != -1 && next_char == close_char
    return 1
  endif
  return 0
endfunction

function! EnterBracket()
  if s:IsInsideBracket()
    return "\<cr>\<esc>ko"
  else
    return "\<cr>"
  endif
endfunction


function! BackspaceBracket()
  if s:IsInsideBracket()
    return "\<right>\<bs>\<bs>"
  else
    return "\<bs>"
  endif
endfunction

inoremap <expr> <cr> <Nop>
inoremap <expr> <cr> EnterBracket()
inoremap <expr> <bs> BackspaceBracket()
inoremap <expr> ' AutoCloseBrackets("'")
inoremap <expr> " AutoCloseBrackets('"')
inoremap <expr> ( AutoCloseBrackets("(")
inoremap <expr> { AutoCloseBrackets("{")
inoremap <expr> [ AutoCloseBrackets("[")
inoremap <expr> ) AutoCloseBrackets(")")
inoremap <expr> ] AutoCloseBrackets("]")
inoremap <expr> } AutoCloseBrackets("}")

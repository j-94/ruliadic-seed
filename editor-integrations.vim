" Vim/Neovim integration for Codex Agent
" Save this file as ~/.vim/plugin/codex.vim or source it manually

" Codex code generation function
function! CodexGenerate()
    " Get the current line or selection as prompt
    let prompt = input('Codex prompt: ')

    if empty(prompt)
        echo "Codex generation cancelled"
        return
    endif

    " Get current file type for language detection
    let filetype = &filetype
    let language_map = {
        \ 'python': 'python',
        \ 'javascript': 'javascript',
        \ 'typescript': 'typescript',
        \ 'rust': 'rust',
        \ 'go': 'go',
        \ 'java': 'java',
        \ 'cpp': 'cpp',
        \ 'cs': 'csharp',
        \ 'php': 'php',
        \ 'ruby': 'ruby',
        \ 'vim': 'vim'
        \ }

    let language = get(language_map, filetype, 'python')

    echo "Generating code with Codex..."
    echo "Prompt: " . prompt
    echo "Language: " . language

    " Call codex CLI and capture output
    let output = system('cd ' . shellescape(expand('%:p:h')) . ' && codex "' . shellescape(prompt) . '" ' . language)

    " Display results in a new split
    new Codex_Result
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    " Insert the generated code
    call append(0, split(output, "\n"))

    " Remove empty first line if present
    if getline(1) =~ '^$'
        execute "1delete"
    endif

    echo "Code generation complete! Results in Codex_Result buffer"
endfunction

" Codex function explanation
function! CodexExplain()
    " Get current line or selection
    let lines = getline(1, '$')
    let code = join(lines, "\n")

    if empty(code)
        echo "No code to explain"
        return
    endif

    let prompt = "Explain this code in detail:\n\n" . code

    echo "Getting code explanation..."
    let output = system('codex "' . shellescape(prompt) . '"')

    " Display explanation in a new split
    new Codex_Explanation
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    call append(0, split(output, "\n"))

    if getline(1) =~ '^$'
        execute "1delete"
    endif

    echo "Explanation complete! Results in Codex_Explanation buffer"
endfunction

" Codex code review
function! CodexReview()
    " Get current line or selection
    let lines = getline(1, '$')
    let code = join(lines, "\n")

    if empty(code)
        echo "No code to review"
        return
    endif

    let prompt = "Review this code for issues, improvements, and best practices:\n\n" . code

    echo "Reviewing code..."
    let output = system('codex "' . shellescape(prompt) . '"')

    " Display review in a new split
    new Codex_Review
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    call append(0, split(output, "\n"))

    if getline(1) =~ '^$'
        execute "1delete"
    endif

    echo "Code review complete! Results in Codex_Review buffer"
endfunction

" Codex test generation
function! CodexGenerateTests()
    " Get current line or selection
    let lines = getline(1, '$')
    let code = join(lines, "\n")

    if empty(code)
        echo "No code to generate tests for"
        return
    endif

    let prompt = "Generate comprehensive tests for this code:\n\n" . code

    echo "Generating tests..."
    let output = system('codex "' . shellescape(prompt) . '"')

    " Display tests in a new split
    new Codex_Tests
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    call append(0, split(output, "\n"))

    if getline(1) =~ '^$'
        execute "1delete"
    endif

    echo "Test generation complete! Results in Codex_Tests buffer"
endfunction

" Key mappings (customize as needed)
" Generate code: <Leader>cg (Codex Generate)
nmap <Leader>cg :call CodexGenerate()<CR>

" Explain code: <Leader>ce (Codex Explain)
nmap <Leader>ce :call CodexExplain()<CR>

" Review code: <Leader>cr (Codex Review)
nmap <Leader>cr :call CodexReview()<CR>

" Generate tests: <Leader>ct (Codex Tests)
nmap <Leader>ct :call CodexGenerateTests()<CR>

" Commands (for use in command mode)
command! CodexGenerate call CodexGenerate()
command! CodexExplain call CodexExplain()
command! CodexReview call CodexReview()
command! CodexGenerateTests call CodexGenerateTests()

" Auto-completion for Codex prompts (optional)
function! CodexComplete(findstart, base)
    if a:findstart
        " Locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        return start
    else
        " Return completion candidates
        let completions = [
            \ 'Write a function to',
            \ 'Create a class for',
            \ 'Implement a REST API for',
            \ 'Add error handling to',
            \ 'Optimize this code for',
            \ 'Convert this code to',
            \ 'Add unit tests for',
            \ 'Document this function',
            \ 'Refactor this code to',
            \ 'Add type hints to'
            \ ]
        return filter(completions, 'v:val =~ a:base')
    endif
endfunction

" Enable completion if user types 'codex' in insert mode
augroup CodexCompletion
    autocmd!
    autocmd InsertCharPre * if matchstr(getline('.'), '\v\c(codex|generate|write|create|implement|add|optimize|convert|document|refactor)\s+') != '' |
        \ call complete(col('.'), [
        \ 'Write a function to',
        \ 'Create a class for',
        \ 'Implement a REST API for',
        \ 'Add error handling to',
        \ 'Optimize this code for',
        \ 'Convert this code to',
        \ 'Add unit tests for',
        \ 'Document this function',
        \ 'Refactor this code to',
        \ 'Add type hints to'
        \ ]) |
        \ endif
augroup END

" Status line integration (optional)
function! CodexStatus()
    if exists("g:codex_available") && g:codex_available
        return "[Codex:Ready]"
    else
        return "[Codex:Offline]"
    endif
endfunction

" Check if Codex is available on Vim startup
function! CheckCodexAvailability()
    if system('which codex') != ""
        let g:codex_available = 1
        echo "Codex CLI found and ready to use!"
    else
        let g:codex_available = 0
        echo "Codex CLI not found. Install it first."
    endif
endfunction

" Initialize on startup
autocmd VimEnter * call CheckCodexAvailability()

" Help text (shown with :CodexHelp)
function! ShowCodexHelp()
    echo "Codex Vim Integration Help:"
    echo "==========================="
    echo "<Leader>cg    - Generate code from prompt"
    echo "<Leader>ce    - Explain current code"
    echo "<Leader>cr    - Review code for issues"
    echo "<Leader>ct    - Generate tests for code"
    echo ""
    echo "Commands:"
    echo ":CodexGenerate      - Generate code"
    echo ":CodexExplain       - Explain code"
    echo ":CodexReview        - Review code"
    echo ":CodexGenerateTests - Generate tests"
    echo ""
    echo "The Codex CLI must be installed and One Engine running."
    echo "See ruliad-seed/README.md for setup instructions."
endfunction

command! CodexHelp call ShowCodexHelp()

" Optional: Add to status line
" set statusline+=%{CodexStatus()}

echo "Codex Vim integration loaded! Use <Leader>cg to generate code."
echo "Type :CodexHelp for help or :CodexGenerate to start."
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    ensure_installed = { "lua", "python" }, -- a list of languages
    sync_install = false, -- install language synchronously (only applied to `ensure_installed`)
    autopairs = {
        enable = true,
    },
    ignore_install = { "" }, -- List of parsers to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of languages that will be disabled
        additional_vim_regex_highlighting = true,
    },
    indent = { enable = true, disable = { "yaml" } },
    rainbow = {
        enable = true,
        -- disable = {"jsx", "cpp"}, list of language you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lange -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {}, -- table of color name strings
    },
    context_commentstring = {
        enable = true,
    },
})

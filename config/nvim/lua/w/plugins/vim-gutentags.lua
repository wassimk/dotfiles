--
-- vim-gutentags
-- https://github.com/ludovicchabant/vim-gutentags
--

return {
  'ludovicchabant/vim-gutentags',
  init = function()
    -- Use universal-ctags (works with Ruby 3.3+ Prism)
    vim.g.gutentags_ctags_executable = 'ctags'

    -- Exclude common directories that slow down indexing
    vim.g.gutentags_ctags_exclude = {
      '*.git',
      '*.svg',
      '*.hg',
      '*/tests/*',
      'build',
      'dist',
      '*sites/*/files/*',
      'bin',
      'node_modules',
      'bower_components',
      'cache',
      'compiled',
      'docs',
      'example',
      'bundle',
      'vendor',
      '*.md',
      '*-lock.json',
      '*.lock',
      '*bundle*.js',
      '*build*.js',
      '.*rc*',
      '*.json',
      '*.min.*',
      '*.map',
      '*.bak',
      '*.zip',
      '*.pyc',
      '*.class',
      '*.sln',
      '*.Master',
      '*.csproj',
      '*.tmp',
      '*.csproj.user',
      '*.cache',
      '*.pdb',
      'tags*',
      'cscope.*',
      '*.css',
      '*.less',
      '*.scss',
      '*.exe',
      '*.dll',
      '*.mp3',
      '*.ogg',
      '*.flac',
      '*.swp',
      '*.swo',
      '*.bmp',
      '*.gif',
      '*.ico',
      '*.jpg',
      '*.png',
      '*.rar',
      '*.zip',
      '*.tar',
      '*.tar.gz',
      '*.tar.xz',
      '*.tar.bz2',
      '*.pdf',
      '*.doc',
      '*.docx',
      '*.ppt',
      '*.pptx',
      'log',
      'tmp',
    }

    -- Store tags in .git directory
    vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/gutentags')
  end,
}

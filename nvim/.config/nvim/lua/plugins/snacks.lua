local hero_image = [[
                                                                     
       ███████████           █████      ██                     
      ███████████             █████                             
      ████████████████ ███████████ ███   ███████     
     ████████████████ ████████████ █████ ██████████████   
    █████████████████████████████ █████ █████ ████ █████   
  ██████████████████████████████████ █████ █████ ████ █████  
 ██████  ███ █████████████████ ████ █████ █████ ████ ██████ 
 ██████   ██  ███████████████   ██ █████████████████ ]]

return {
  "folke/snacks.nvim",
  opts = {
    -- Dashboard
    dashboard = {
      preset = {
        header = hero_image,
      },
      formats = {
        header = { "%s", align = "left", hl = "normal" },
      },
    },
    -- Picker: use fd + ripgrep with hidden files, exclude common junk
    picker = {
      sources = {
        -- Explorer: show hidden + ignored files, but exclude common noise
        explorer = {
          hidden = true,
          ignored = true, -- show gitignored files like .env
          exclude = {
            "__pycache__",
            ".cache",
            ".DS_Store",
            ".git",
            ".mypy_cache",
            ".next",
            ".pytest_cache",
            ".turbo",
            ".venv",
            ".vercel",
            "build",
            "coverage",
            "dist",
            "node_modules",
            "venv",
          },
        },
        files = {
          hidden = true,
          ignored = true, -- include .env files
          exclude = {
            "__pycache__",
            ".cache",
            ".DS_Store",
            ".git",
            ".mypy_cache",
            ".next",
            ".pytest_cache",
            ".turbo",
            ".venv",
            ".vercel",
            "build",
            "coverage",
            "dist",
            "node_modules",
            "venv",
          },
        },
        grep = {
          hidden = true,
          ignored = false, -- respect .gitignore for grep (don't search in node_modules)
        },
      },
    },
  },
}

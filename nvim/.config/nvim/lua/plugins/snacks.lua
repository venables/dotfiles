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
        -- Explorer: show hidden files by default
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
          ignored = false, -- respect .gitignore
        },
        grep = {
          hidden = true,
          ignored = false, -- respect .gitignore
        },
      },
    },
  },
}

--[[                                                             
                                                              
   ,---,           ,---,.               .--.--.    .--.--.    
  '  .' \        ,'  .'  \       ,---, /  /    '. /  /    '.  
 /  ;    '.    ,---.' .' |      /_ ./||  :  /`. /|  :  /`. /  
:  :       \   |   |  |: |,---, |  ' :;  |  |--` ;  |  |--`   
:  |   /\   \  :   :  :  /___/ \.  : ||  :  ;_   |  :  ;_     
|  :  ' ;.   : :   |    ; .  \  \ ,' ' \  \    `. \  \    `.  
|  |  ;/  \   \|   :     \ \  ;  `  ,'  `----.   \ `----.   \ 
'  :  | \  \ ,'|   |   . |  \  \    '   __ \  \  | __ \  \  | 
|  |  '  '--'  '   :  '; |   '  \   |  /  /`--'  //  /`--'  / 
|  :  :        |   |  | ;     \  ;  ; '--'.     /'--'.     /  
|  | ,'        |   :   /       :  \  \  `--'---'   `--'---'   
`--''          |   | ,'         \  ' ;                        
               `----'            `--`                         
                           ,-.----.                           
               ,---,       \    /  \      ,---,.              
       ,---.  '  .' \      |   :    \   ,'  .' |              
      /__./| /  ;    '.    |   |  .\ :,---.'   |              
 ,---.;  ; |:  :       \   .   :  |: ||   |   .'              
/___/ \  | |:  |   /\   \  |   |   \ ::   :  |-,              
\   ;  \ ' ||  :  ' ;.   : |   : .   /:   |  ;/|              
 \   \  \: ||  |  ;/  \   \;   | |`-' |   :   .'              
  ;   \  ' .'  :  | \  \ ,'|   | ;    |   |  |-,              
   \   \   '|  |  '  '--'  :   ' |    '   :  ;/|              
    \   `  ;|  :  :        :   : :    |   |    \              
     :   \ ||  | ,'        |   | :    |   :   .'              
      '---" `--''          `---'.|    |   | ,'                
   vape/CustomModules/18901165922.lua by abyss 100%!                          `---`    `----'                  
 --]]                                                             
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Abyss Pets Go Loader", "BloodTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Load")
Section:NewButton("Load Pets go", "Loads abyss pets go", function()
    local gamesScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/GameList.lua"))()
    
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
        end
    end
end)
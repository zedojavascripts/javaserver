local urlScript = 'https://raw.githubusercontent.com/Brinquee/testee/refs/heads/main/main.lua?token=GHSAT0AAAAAAEA7IXK5N3TGSENBEDRFKN422UM5TOA';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

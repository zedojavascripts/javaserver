local urlScript = 'https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/svtrovy.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

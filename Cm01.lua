local urlScript = 'https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/svtrovy.lua?token=GHSAT0AAAAAAEEYZWN7KF4XFEOHAJABUDOA2UM6D4A';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

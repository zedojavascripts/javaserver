local urlScript = 'https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/svtrovy.lua?token=GHSAT0AAAAAAEEYZWN7DTWWTNUBLULPDGLQ2UM6FLQ';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

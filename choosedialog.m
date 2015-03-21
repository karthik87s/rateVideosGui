function [nameSubject, choice, choice_idx] = choosedialog

    nameSubject = '';
    choice = '1-180';
    choice_idx = 1;
    d = dialog('Position',[700 500 350 250],'Name','Enter name and select annotation set');
    txt1 = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[70 200 210 40],...
           'String','Enter your name');

    txt2 = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[80 100 210 40],...
           'String','Select a set of videos to annotate');
       
    edit = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[110 170 130 40],'Callback',@edit_callback);
       
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[130 70 100 25],...
           'String',{'1-180';'1-90';'91-180';'181-360';'181-270';'271-360'},...
           'Callback',@popup_callback);
       
    btn = uicontrol('Parent',d,...
           'Position',[145 20 70 25],...
           'String','Done',...
           'Callback','delete(gcf)');
       
     
    % Wait for d to close before running to completion
    uiwait(d); 
    
function popup_callback(popup,callbackdata)
    choice_idx = popup.Value;
    popup_items = popup.String;
    choice = char(popup_items(choice_idx,:));
end

function edit_callback(edit,callbackdata)
    editVal = edit.String;
    nameSubject = editVal;
end

end
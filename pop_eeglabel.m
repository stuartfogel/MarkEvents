function [com] = pop_eeglabel(EEG)
% pop_eeglabel() -  Opens an EEGPLOT window with a button that allows the
% labeling of EEG periods. 
%
% Usage:
%   >> [com] = pop_eeglabel(EEG)
%
% Inputs:
%   EEG - EEGLAB dataset structure
%
% Outputs:
%   com - The equivalent command line command
%
% Author: German Gomez-Herrero <german.gomezherrero@tut.fi>
%         Institute of Signal Processing
%         Tampere University of Technology, 2008
%
% See also:
%   EEGLABEL, EEGPLUGIN_MARKEVENTS, EEGLAB
%
% Author: German Gomez-Herrero <german.gomezherrero@tut.fi>
%         Institute of Signal Processing
%         Tampere University of Technology, 2008
%
% Copyright (C) <2007>  German Gomez-Herrero, http://germangh.com%
%
% Modifed by Stuart Fogel to work with newer eeglab versions
% Brain & Mind Institute, Western University, Canada
% July 7, 2014

com = '';
if nargin < 1, 
    help pop_eeglabel;
    return;
end

command = ...
    [ '[EEGTMP LASTCOM] = me_eeglabel(EEG,eegplot2event(TMPREJ,-1));',...
    'if ~isempty(LASTCOM),' ...
    '  [ALLEEG EEG CURRENTSET tmpcom] = pop_newset(ALLEEG, EEGTMP, CURRENTSET);' ...
    '  if ~isempty(tmpcom),' ...
    '     EEG = eegh(LASTCOM, EEG);' ...
    '     eegh(tmpcom);' ...
    '     eeglab(''redraw'');' ...
    '  end;' ...
    'end;' ...
    'clear EEGTMP tmpcom;' ];


ctrlselectcommand = ...
{'lat1=get(findobj(''tag'',''eegaxis'',''parent'',gcf), ''currentpoint'');', 'lat2=get(findobj(''tag'',''eegaxis'',''parent'',gcf), ''currentpoint'');','EEG = me_deleteevent(EEG,get(gcf,''UserData''),lat1,lat2);'};

% call eegplot with the appropriate options
chaninds=[1:length(EEG.chanlocs)];
me_eegplot( EEG.data(chaninds,:,:), ...
	'eloc_file',EEG.chanlocs(chaninds), ... ...
    'srate', EEG.srate, ...
    'title', 'Scroll channel activities -- eegplot()', ...
    'limits', [EEG.xmin EEG.xmax]*1000 , ...
    'winlength' , 30, ...
    'xgrid', 'on', ...
    'command', command, ...
    'ctrlselectcommand', ctrlselectcommand, ...
    'butlabel','LABEL EVENTS', ...
    'events',EEG.event); 

com = [ com sprintf('pop_eeglabel( %s);', inputname(1)) ]; 
return;
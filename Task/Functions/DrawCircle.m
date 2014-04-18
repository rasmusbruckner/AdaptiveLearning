function DrawCircle(window)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here





screensize = get(0,'MonitorPositions'); 
%screensize = get(0, 'ScreenSize');
screensize = (screensize(3:4));


zero = screensize / 2;


Screen(window,'FrameOval',[128 128 128],[zero(1) - 105, zero(2) - 105, zero(1) + 105, zero(2) + 105],[],[10],[]); %615 345 825 555
                                                        
                                                      


end


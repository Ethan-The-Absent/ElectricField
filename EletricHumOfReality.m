%% The Eletric Hum of Reality
clear; close all;
universe = figure(1);

set(universe, 'KeyPressFcn', @Key)
scale = 30;
SpeedOfLight = 50;

particle(1).vel = [0, 0];
particle(1).acc = [0, 0];
particle(1).pos = [10, 10];
particle(1).charge = 10;
particle(1).mass = 1;

particle(2).vel = [0, 0];
particle(2).acc = [0, 0];
particle(2).pos = [0, 0];
particle(2).charge = -10;
particle(2).mass = 1;

particle(3).vel = [0, 0];
particle(3).acc = [0, 0];
particle(3).pos = [50, 50];
particle(3).charge = -10;
particle(3).mass = 10;

for c = 4:8
particle(c).vel = [0,0];
particle(c).acc = [0, 0];
particle(c).pos = [randi(scale)-scale/2,randi(scale)-scale/2];
particle(c).charge = randi(10)-5;
particle(c).mass = 1;
end


setappdata(gcf,'key',2)
whitebg([0 0 0]); %#ok<WHITEBG>

play = true;
t = 0.05;
y = 0;
while play == true
    %% Commands
    figure(1)
    switch getappdata(gcf,'key')
        case 0
            play = false;
        case 1
            input('>> ','s');
            setappdata(gcf,'key',2)
    end
    
    %% Forces
    for c = 1:length(particle)
        particle(c).acc = [0 0];
    end
    for c = 1:length(particle)
        
        for d = 1:length(particle)
            if c ~= d
                r = (sqrt((particle(c).pos(1)-particle(d).pos(1))^2 + (particle(c).pos(2)-particle(d).pos(2))^2));
                F = ((particle(d).charge)*(particle(c).charge)/(r^2));
                angle = atand((particle(d).pos(2) - particle(c).pos(2)) / (particle(d).pos(1) - particle(c).pos(1)));
                 if particle(c).pos(1) < particle(d).pos(1)
                     particle(c).acc(1) = particle(c).acc(1) - cosd(angle)*F;
                else
                    particle(c).acc(1) = particle(c).acc(1) + cosd(angle)*F;
                end
               if particle(c).pos(2) < particle(d).pos(2)
                     particle(c).acc(2) = particle(c).acc(2) - sind(angle)*F;
                else
                    particle(c).acc(2) = particle(c).acc(2) + sind(angle)*F;
                end
                
            end
        end
    end
    
    
    for c = 1:length(particle)
        particle(c).vel(1) = particle(c).vel(1) + particle(c).acc(1)*t/particle(c).mass;
        particle(c).vel(2) = particle(c).vel(2) + particle(c).acc(2)*t/particle(c).mass;
    end
    %% Displacement
    for c = 1:length(particle)
        particle(c).pos(1) = min([SpeedOfLight particle(c).vel(1)*t]) + particle(c).pos(1);
        particle(c).pos(2) = min([SpeedOfLight particle(c).vel(2)*t]) + particle(c).pos(2);
    end
    
    %% Plot
    if  y == 2
    hold off
    for c = 1:length(particle)
        if particle(c).charge > 0
            plot([particle(c).pos(1) particle(c).pos(1)+2],[particle(c).pos(2) particle(c).pos(2)+2],'y')
        else
            plot([particle(c).pos(1) particle(c).pos(1)+2],[particle(c).pos(2) particle(c).pos(2)+2],'c')
        end
        hold on
    end
    axis([-scale,scale,-scale,scale])
    drawnow
    y = 0;
    else
        y = y+1;
    end
end

function Key(gcf,event)
switch event.Key
    case 'escape'
        setappdata(gcf,'key',0)
    case 'slash'
        setappdata(gcf,'key',1)
end
end

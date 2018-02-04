 %行进方向计算      
function orentation=getorentation(pointa_lat,pointa_lon,pointb_lat,pointb_lon)
        deta_arclat = (pointa_lat-pointb_lat) * pi/ 180 ;
        deta_arclon = (pointa_lon-pointb_lon) * pi/ 180 ;
        deta_lat = deta_arclat*6371004/(2*pi);
        deta_lon = deta_arclon*6371004*cos(deta_arclat)/(2*pi);
        
        if deta_lat>0
            if deta_lon>0
            orentation = atan2(deta_lon,deta_lat)*180/pi;
            else
            orentation = (atan2(deta_lon,deta_lat)+2*pi)*180/pi;
            end
        else
                if deta_lon>0
                 orentation = atan2(deta_lon,deta_lat)*180/pi;
                else
                orentation = (atan2(deta_lon,deta_lat)+2*pi)*180/pi;
                end
        end
                    
                    
        
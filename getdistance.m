 %ÇòÃæ¾àÀë¹«Ê½      
function distance=getdistance(pointa_lat,pointa_lon,pointb_lat,pointb_lon)
        wj_a = sin(pointa_lat * pi/ 180) * sin(pointb_lat * pi/ 180);
        wj_b = cos(pointa_lat * pi/ 180) * cos(pointb_lat * pi / 180) * cos((pointb_lon - pointa_lon) * pi/ 180);
        if((wj_a + wj_b) <= 1 )
            distance = 6371004 *acos(wj_a + wj_b) / 1000;
        else 
            distance=0;
        end
        

    
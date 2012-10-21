import UnityEngine

class HSVColor (MonoBehaviour): 
        //reference http://ja.wikipedia.org/wiki/HSV%E8%89%B2%E7%A9%BA%E9%96%93
        static def GetColorFromHSV( hue as single, saturation as single, val as single ) as Color:
                if saturation <= 0.0f:
                	return Color( val, val, val );
                
                h as int = ( hue / 60 ) % 6;
                f as single = hue / 60 - h;
                p as single = val * ( 1 - saturation );
                q as single = val * ( 1 - f * saturation);
                t as single = val * ( 1 - ( 1 - f ) * saturation );
                
                if h == 0:
                	return Color( val, t, p )
                	
                elif h == 1:
                    return Color( q, val, p )
                
                elif h == 2:
                    return Color( p, val, t )
               
                elif h == 3:
                    return Color( p, q, val )
                
                elif h == 4:
                    return Color( t, p, val )
                
                elif h == 5:
                    return Color( val, p, q )
                return Color.white
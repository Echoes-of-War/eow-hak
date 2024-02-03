#include "crp_inc_control"
void main()
{
    object oMod = OBJECT_SELF;
    int iWait = GetLocalInt(oMod,"WAIT");
    if (iWait > 0)
    {
        iWait--;
        SetLocalInt(oMod,"WAIT",iWait);
        return;
    }
    else
    {
        int iWeather = d100();
        if(iWeather <= CHANCE_OF_PRECIPITATION)
        {
            SetWeather(oMod,PRECIPITATION);
        }
        else
        {
            SetWeather(oMod,WEATHER_CLEAR);
        }
        SetLocalInt(oMod,"WAIT",(d20(2)* d3()));
    }
}

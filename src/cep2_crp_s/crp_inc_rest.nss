/*  CRAP REST SYSTEM INCLUDE - inc_rest
    v1.00 9/11/2004
    by Kerry Solberg - http://www.realmsofmyth.org
*/

#include "crp_inc_control"


//Returns a value from 0 - 5 based on the resting conditions available.
// 0 = very poor, 1 = poor, 2 = fair, 3 = good, 4 = excellent, 5 = best :
int GetSleepingCondition(object oPC, int nIndoors);

// Returns 999 if enough hours have passed to allow the player to rest again.
// If not enough hours have passed, returns the numbers of hours remaining.
int GetIsRestingAllowed(object oPC);

// Returns 999 if enough hours have passed to allow the player to meditate again.
// If not enough hours have passed, returns the numbers of hours remaining.
int GetIsMeditationAllowed(object oPC);

int GetHPAfterResting(object oPC, int nConditions);

int GetSleepingCondition(object oPC, int nIndoors)
{
/*
    ----------------------------------------------------------------------------
    CONDITIONS                                          OUTDOORS       INDOORS
    ----------------------------------------------------------------------------
    no bedroll, campfire or tent - raining or snowing      0             NA
    no bedroll, campfire, tent or bed                      1             1
    bedroll only                                           2             3
    campfire only                                          2             2
    tent only                                              2             NA
    tent & campfire                                        3             NA
    bedroll & tent                                         3             NA
    bedroll & campfire                                     3             4
    bedroll, campfire, and tent                            4             NA
    bed                                                    NA            5
    ----------------------------------------------------------------------------
*/

    int nBedRoll, nCampfire, nTent, nBadWeather;
    float fFDis, fTDis;
    switch(nIndoors)
    {
        case FALSE:  //Outdoors
        fFDis = GetDistanceBetween(oPC, GetNearestObjectByTag("Campfire", oPC));
        fTDis = GetDistanceBetween(oPC, GetNearestObjectByTag("crpp_tent", oPC));
        nBedRoll = GetIsObjectValid(GetItemPossessedBy(oPC, "crpi_bedroll"));
        nCampfire = (fFDis > 0.0f && fFDis < 5.0f);
        nTent = (fTDis > 0.0f && fTDis < 8.0f);
        nBadWeather = GetWeather(GetArea(oPC)) != WEATHER_CLEAR;
        if(nBedRoll == TRUE && nCampfire == TRUE && nTent == TRUE)
            return 4;
        else if((nBedRoll == TRUE && nCampfire == TRUE) ||
           (nTent == TRUE && nCampfire == TRUE)    ||
           (nBedRoll == TRUE && nTent == TRUE))
            return 3;
        else if(nBedRoll == TRUE || nCampfire == TRUE || nTent == TRUE)
            return 2;
        else if(nBadWeather == TRUE)
            return 0;
        else
            return 1;

        case TRUE:  //Indoors
        fFDis = GetDistanceBetween(oPC, GetNearestObjectByTag("Campfire", oPC, 1));
        fTDis = GetDistanceBetween(oPC, GetNearestObjectByTag("Bed", oPC, 1));
        nBedRoll = GetIsObjectValid(GetItemPossessedBy(oPC, "crpi_bedroll"));
        nCampfire = (fFDis > 0.0f && fFDis < 5.0f);
        nTent = (fTDis > 0.0f && fTDis < 4.0f);
        if(nTent == TRUE)
            return 5;
        if(nBedRoll == TRUE && nCampfire == TRUE)
            return 4;
        if(nBedRoll == TRUE)
            return 3;
        if(nCampfire == TRUE)
            return 2;
        return 1;
    }

    if(CRP_DEBUG == 1) SendMessageToPC(oPC, "Could not determine resting conditions");

    return 5;
}

int GetIsRestingAllowed(object oPC)
{
    int nTime = GetCalendarYear() * 1000000 + GetCalendarMonth() * 10000 +
                GetCalendarDay() * 100 + GetTimeHour();
    int nNextRest = GetLocalInt(oPC, "LAST_RESTED") + REST_WAIT;

    if(nTime >= nNextRest)
    {
        return 999;
    }
    else
        return nNextRest - nTime;
}

/*int GetIsMeditationAllowed(object oPC)
{
    int nTime = GetCalendarYear() * 1000000 + GetCalendarMonth() * 10000 +
                GetCalendarDay() * 100 + GetTimeHour();
    int nNextMed = GetLocalInt(oPC, "LAST_MEDITATED") + MEDITATION_WAIT;

    if(nTime >= nNextMed)
    {
        return 999;
    }
    else
        return nNextMed - nTime;
}*/

int GetHPAfterResting(object oPC, int nConditions)
{
    /*
    CONDITION                   RETURN  HP REGAINED
    ----------------------------------------------------------
    very poor                   0       10% + (1/2 Con Bonus)
    poor                        1       20% + Con Bonus
    fair                        2       30% + Con Bonus
    good                        3       45% + Con Bonus
    very good                   4       60% + (2 * Con Bonus)
    bed                         5       full hp
    ----------------------------------------------------------
    */

    float fConstitution = GetAbilityModifier(ABILITY_CONSTITUTION, oPC) * 0.01;
    int nCHP = GetCurrentHitPoints(oPC);
    int nMaxHP = GetMaxHitPoints(oPC);
    int nAddHP, nNewHP;
    switch(nConditions)
    {
        case 0:
            nAddHP = FloatToInt((nMaxHP * (0.1 + fConstitution * 0.5)));
            break;
        case 1:
            nAddHP = FloatToInt((nMaxHP * (0.2 + fConstitution)));
            break;
        case 2:
            nAddHP = FloatToInt((nMaxHP * (0.3 + fConstitution)));
            break;
        case 3:
            nAddHP = FloatToInt((nMaxHP * (0.45 + fConstitution)));
            break;
        case 4:
            nAddHP = FloatToInt((nMaxHP * (0.6 + fConstitution * 2)));
            break;
        case 5:
            nAddHP = nMaxHP;
    }

    if(CRP_DEBUG == 1)
        SendMessageToPC(oPC, "Add HP: " + IntToString(nAddHP));

    nNewHP = nCHP + nAddHP;
    return nNewHP;
}

int HasTinder(object oPC)
{
    int nTinder, nWood, nWood2;
    object oTinder = GetItemPossessedBy(oPC, "crpi_tinderbox");
    if(GetIsObjectValid(oTinder))
    {
        SetLocalObject(oPC, "TINDER", oTinder);
        nTinder = TRUE;
    }
    //int nTinder = GetIsObjectValid(GetItemPossessedBy(oPC, "crp_tinderbox"));
    object oWood = GetItemPossessedBy(oPC, "crpi_wood01");
    if(GetIsObjectValid(oWood))
    {
        SetLocalObject(oPC, "FIREWOOD", oWood);
        nWood = TRUE;
    }
    object oWood2 = GetItemPossessedBy(oPC, "crpi_wood02");
    if(GetIsObjectValid(oWood2))
    {
        SetLocalObject(oPC, "FIREWOOD", oWood2);
        nWood = TRUE;
    }
    if(nWood && nTinder)
        return TRUE;
    else
        return FALSE;
}

string GetTentType(object oPC)
{
    object oTent = GetItemPossessedBy(oPC, "crpi_adv_tent02");
    if(GetIsObjectValid(oTent))
    {
        SetLocalObject(oPC, "TENT", oTent);
        return "crpp_tent02";
    }
    oTent = GetItemPossessedBy(oPC, "crpi_adv_tent01");
    if(GetIsObjectValid(oTent))
    {
        SetLocalObject(oPC, "TENT", oTent);
        return "crpp_tent01";
    }
    return "";
}

void MakeCampFire(location lLoc)
{
    object oFire = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_campfr", lLoc);
    DelayCommand(75.0, DestroyObject(oFire));
}

void RaiseTent(string sResRef, location lLoc)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc);
}

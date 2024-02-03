/*
Checks a spawned creature to see whether setting a
FIGHT_OR_FLIGHT variable is warranted

010603 Testing shows this works quite well. Dominated
creatures will be tested for in the actual FIGHT_OR_FLIGHT
script.
012703 Had to change the check for undead/construct class to
a check for racial type--Curst have regular PC classes but are
considered undead by race.
*/

void main()
{
//basic restrictions: caller is not undead, construct, or HD > 5
if (GetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD &&
    GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT &&
    (GetHitDice(OBJECT_SELF) < 10 || GetChallengeRating(OBJECT_SELF) < 10.0)) //fairly arbitrary, but we can work with it
    {
    //Feat-based restrictions: caller has no special fear immunity
    if (!GetHasFeat(FEAT_AURA_OF_COURAGE,OBJECT_SELF) &&
        !GetHasFeat(FEAT_FEARLESS,OBJECT_SELF) &&
        !GetHasFeat(FEAT_RESIST_NATURES_LURE))
        {
        //Is it too stupid to know better? Caller has basic intelligence.
        if (GetAbilityScore(OBJECT_SELF,ABILITY_INTELLIGENCE) > 5)
            {
            SetLocalInt(OBJECT_SELF,"FIGHT_OR_FLIGHT",1);
            SetListening(OBJECT_SELF,TRUE);
            SetListenPattern(OBJECT_SELF,"RETREAT_CHECK",5000);
            SetListenPattern(OBJECT_SELF,"GUARD_ME",5001);

            //FOF 011203: Set Green/Seasoned/Veteran by HD
            //Veterans = HD 5
            if (GetHitDice(OBJECT_SELF) > 4)
                SetLocalFloat(OBJECT_SELF,"fRaw",5.0);
            //Seasoned = HD 3-4
            if (GetHitDice(OBJECT_SELF) == 3 || GetHitDice(OBJECT_SELF) == 4)
                SetLocalFloat(OBJECT_SELF,"fRaw",4.0);
            //Green = HD 1-2
            if (GetHitDice(OBJECT_SELF) == 1 || GetHitDice(OBJECT_SELF) == 2)
                SetLocalFloat(OBJECT_SELF,"fRaw",3.0);
            }
        }
    }
}

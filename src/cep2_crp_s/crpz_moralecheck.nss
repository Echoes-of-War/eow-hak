////////////////////////////////////////////////////////////////
//FIGHT_OR_FLIGHT
//Jeff Peterson, 01/03
///////////////////
//The guts of a morale system. Gets called from a creature's
//OnDamaged to determine whether the caller should stand
//and fight or retreat. My modified NW_C2_DEFAULT6 fires
//this in the event (my modified) NW_C2_DEFAULT9 sets a local
//int indicating potential to retreat. This same script is also
//called (via a shout) when an ally retreats or is killed.
//
//Technical note: I have added a tiny sum, 0.01, to the
//denominators of all the division operations in order to
//sidestep any sneaky "divide by zero" problems. This should
//not interfere too much with accurate calculation. I suppose
//it could be smaller, though I suppose I could be smart enough
//to work 'round it.
//
////////////////////////////////////////////////////////////////
#include "crp_inc_fof"
#include "NW_I0_GENERIC"

void CallForHelp();

void main()
{
    object oEnemy;
    object oMaster;
    int nDom;
    float f_SelfCR = GetChallengeRating(OBJECT_SELF);
    float fRange = 20.0;
    float fEnemyCR;
    float fCompare;
    float fHP = IntToFloat(GetCurrentHitPoints(OBJECT_SELF));
    float fMax = IntToFloat(GetMaxHitPoints(OBJECT_SELF));
    int nFloor;
    float fRaw = GetLocalFloat(OBJECT_SELF,"fRaw");
    float f_TheirCR;
    float f_OurCR;
    object oTheirs;
    object oMine;
    float fGroupDiff;
    float fEnemyHP;
    float fEnemyMax;
    float fEnemyPercentage;
    float fMyPercentage;
    int nSave;
    float fBase = 20.0;

    //Determine oEnemy
    if (GetLastHostileActor() != OBJECT_INVALID)
    {
        oEnemy = GetLastHostileActor();
    }
    else
    {
        oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
    }

    //A quick check to see if oEnemy is dominated
    oMaster = GetMaster(oEnemy);
    if (GetIsObjectValid(oMaster))
    {
        if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oMaster)))
        {
        if (GetAssociate(ASSOCIATE_TYPE_DOMINATED,oMaster) == oEnemy)
            {
                nDom = 1;
            }
            else
            {
                nDom = 0;
            }
        }
    }

    //Gets the individual enemy's CR or HD, as appropriate
    fEnemyCR = GetEnemyCR(oEnemy,fEnemyCR);

    //Compares caller's to enemy's CR. fCompare will impact the
    //key denominator later.
    fCompare = f_SelfCR / (fEnemyCR + 0.01);

    //Get the enemy group's total CR or HD, as appropriate
    f_TheirCR = GetTheirCR(oEnemy,f_TheirCR,fRange,oTheirs);

    //Get the caller's group's total CR or HD, as appropriate.
    f_OurCR = GetOurCR(f_OurCR,fRange,oMine);

    //Compares caller group's to enemy group's CR. fGroupDiff
    //will impact the key denominator later.
    fGroupDiff = f_OurCR / (f_TheirCR + 0.01);

    //HERE IS THE IMPORTANT LINE:
    //At a base level of 4.0 for fRaw, in combats where the
    //opponents and groups are evenly matched, the caller will
    //flee when HP reaches 1/6 of max.
    nFloor = FloatToInt(fMax / (fRaw * (fCompare + fGroupDiff + 0.01)));

    //Use the same factors to modify the base Fear save
    nSave = FloatToInt(fBase / (fCompare + fGroupDiff + 0.01));

    //How bad off is the enemy?
    fEnemyHP = IntToFloat(GetCurrentHitPoints(oEnemy));
    fEnemyMax = IntToFloat(GetMaxHitPoints(oEnemy));
    fEnemyPercentage = fEnemyHP / (fEnemyMax + 0.01);

    //How bad off am I?
    fMyPercentage = fHP / (fMax + 0.01);

    //A bit of a fig leaf here to allow creatures who heard
    //the RETREAT_CHECK shout to run even if they are in
    //better HP shape than oEnemy.
    int nHPCheck;
    if (fMyPercentage < fEnemyPercentage || GetLocalInt(OBJECT_SELF,"HEARD_THE_CALL") == 1)
    {
        nHPCheck = 1;
    }

    //Issues the command to do a Will save vs Fear if caller's
    //HP falls below the floor AND caller is in worse HP shape
    //than its opponent (to give the monsters SOME incentive to
    //slug it out).
    if (GetCurrentHitPoints(OBJECT_SELF) <= nFloor
            && nHPCheck == 1)
    {
    //A little bit to exclude dominated creatures.
    if (nDom == 0)
        {
            //Performs a will save modified by the factors.
            //Current base of 20 is deceptive; for equal
            //individual/group strengths, the save is 10, or
            //20 / (1 + 1)
            if (WillSave(OBJECT_SELF,nSave,SAVING_THROW_TYPE_FEAR,oEnemy) == 0)
            {
                SignalFlee(oEnemy,fRange);
                ActionDoCommand(DetermineCombatRound());
            }
            else
            {
                //If you've made your will save and you're
                //a leader, you still summon allies to help you.
                if (GetLocalInt(OBJECT_SELF,"I_AM_A_LEADER") == 1)
                    CallForHelp();
                else
                    DetermineCombatRound();
            }

        }
    }
    //Reset HEARD_THE_CALL to zero in the event this script
    //was called by a RETREAT_CHECK shout.
    SetLocalInt(OBJECT_SELF,"HEARD_THE_CALL",0);
}

void CallForHelp()
{
    SpeakString("GUARD_ME",TALKVOLUME_SILENT_TALK);
    DetermineCombatRound();
}

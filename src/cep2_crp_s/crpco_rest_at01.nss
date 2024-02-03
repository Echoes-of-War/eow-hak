//moved most of the code from mod_rest to here

#include "x0_i0_position"
#include "crp_inc_rest"
#include "crp_inc_paw"

object oPC = OBJECT_SELF;

void crp_FinishRest()
{
    SendMessageToPC(oPC, "Finished Resting");
    ForceRest(oPC);

    int nTime = GetCalendarYear() * 1000000 + GetCalendarMonth() * 10000 +
                GetCalendarDay() * 100 + GetTimeHour();
    SetLocalInt(oPC, "LAST_RESTED", nTime);

    if(CRP_USE_RESTING_RULES != 0)
    {
        //if(GetIsObjectValid(GetLocalObject (oPC, "o_PL_Bedrollrest")))
        //{
        //    DestroyObject (GetLocalObject (oPC, "o_PL_Bedrollrest"), 0.0f);
        //    DeleteLocalObject (oPC, "o_PL_Bedrollrest");
        //}
        int nCHP = GetCurrentHitPoints(oPC);
        int nNHP = GetLocalInt(oPC, "HP_AFTER_RESTING");

        //The Math
        if(nCHP <= nNHP)
        {
            //DeleteLocalInt(oPC, "RESTING");
            return;
        }
        int nDmg = nCHP - nNHP;
        if(nDmg < 0)
        {
            //DeleteLocalInt(oPC, "RESTING");
            return;
        }
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg), oPC));
    }
    //DeleteLocalInt(oPC, "RESTING");

}
void main()
{
    ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
    ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND));
    SendMessageToPC(oPC, "Resting Mode Started: - Your character will be exported");
    int nConditions;

    if(CRP_USE_RESTING_RULES != 0)
    {
        ExportSingleCharacter(oPC);
        int nIndoors = GetIsAreaInterior(GetArea(oPC));
        nConditions = GetSleepingCondition(oPC, nIndoors);

        //Debug Message
        if(CRP_DEBUG) SendMessageToPC(oPC, "Resting Condition: " + IntToString(nConditions));

        int nNewHP = GetHPAfterResting(oPC, nConditions);
        SetLocalInt(oPC, "HP_AFTER_RESTING", nNewHP);
    }

    //Sleep Effects
    DelayCommand(3.0, crp_PlayAnimation(ANIMATION_REST));
    //DelayCommand(1.0, ActionPlayAnimation(ANIMATION_REST, 1.0, 15.0)); //code addition
    if(nConditions != 5 && GetIsObjectValid(GetItemPossessedBy(oPC, "crpi_bedroll")))
    {
        float fDir = GetFacing(oPC);
        float fRight = GetRightDirection(fDir);
        location lBedRoll = GenerateNewLocation(oPC, 0.25, fRight, fDir);
        object oRestbedroll = CreateObject (OBJECT_TYPE_PLACEABLE,"plc_bedrolls", lBedRoll, FALSE);
        SetLocalObject (oPC, "o_PL_Bedrollrest", oRestbedroll);
        DelayCommand(21.0, DestroyObject(oRestbedroll));
        DelayCommand(21.0, DeleteLocalObject(oPC, "o_PL_Bedrollrest"));
    }
    effect eSleep = EffectVisualEffect(VFX_IMP_SLEEP);
    DelayCommand(5.5, ApplyEffectToObject(DURATION_TYPE_INSTANT ,eSleep, oPC));
    DelayCommand(6.5,FadeToBlack(oPC,FADE_SPEED_FAST));
    DelayCommand(13.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
    DelayCommand(3.5, SetCommandable(FALSE, oPC));
    DelayCommand(17.0, SetCommandable(TRUE, oPC));
    DelayCommand(17.05, ActionDoCommand(crp_FinishRest()));
}

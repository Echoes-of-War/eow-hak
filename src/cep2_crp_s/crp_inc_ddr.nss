#include "crp_inc_control"
#include "nw_i0_generic"

object oDying = GetLastPlayerDying();
float fBleedDelay = CRP_FAST_BLEED_DELAY;

void Stablize(effect eHeal, object oWounded);

int HasBeenHealedRecently(object oWounded)
{
    int nTime = GetCalendarYear() * 1000000 +
                GetCalendarMonth() * 10000 +
                GetCalendarDay() * 100 +
                GetTimeHour();
    int nLastHealed = GetLocalInt(oWounded, "LAST_HEALED");
    if(nTime > nLastHealed)
        return FALSE;
    else
        return TRUE;
}

void Stablize(effect eHeal, object oWounded)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oWounded);
    DelayCommand(1.0, FloatingTextStringOnCreature("Your bleeding has stablized.", oWounded, FALSE));
}

void DeincrementBandages()
{
    object oItem = GetItemActivated();
    if(GetTag(oItem) != "crpi_bandages")
        oItem = GetItemPossessedBy(OBJECT_SELF, "crpi_bandages");
    int nStack = GetItemStackSize(oItem);
    if(nStack > 1)
        SetItemStackSize(oItem, nStack - 1);
    else
        DestroyObject(oItem);
}

void AttemptToStablize(object oPC, object oWounded)
{
    int iCurrHP = GetCurrentHitPoints(oWounded);
    effect eHeal;
    if(GetDistanceBetween(oPC, oWounded) > 2.0f)
    {
        SendMessageToPC(oPC, "You're target is too far away to heal.");
        return;
    }
    if(HasBeenHealedRecently(oWounded))
    {
        SendMessageToPC(oPC, "You apply more bandages, but they have little effect.");
        DeincrementBandages();
        return;
    }

    DeincrementBandages();

    if(GetIsSkillSuccessful(oPC, SKILL_HEAL, 15))
    {
        //Stablize Bleeding
        if(iCurrHP < 1 && iCurrHP > -10)
        {
            eHeal = EffectHeal((iCurrHP * -1) + 5);
            Stablize(eHeal, oWounded);
            FloatingTextStringOnCreature("Success", oPC);
            return;
        }
        else
        {
            eHeal = EffectHeal(1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oWounded);
            int nTime = GetCalendarYear() * 1000000 +
                        GetCalendarMonth() * 10000 +
                        GetCalendarDay() * 100 +
                        GetTimeHour();
            SetLocalInt(oWounded, "LAST_HEALED", nTime);
            return;
        }
    }
    FloatingTextStringOnCreature("You fail to stablize the bleeding.", oPC, FALSE);
}

void Bleed()
{

    effect eBleedEff;
    object oFriend;
    int iCurrHP = GetCurrentHitPoints();
    /* keep executing recursively until character is dead or at +1 hit points */
    if (iCurrHP <= 0)
    {
        if(d100() <= (10 + GetAbilityModifier(ABILITY_CONSTITUTION, oDying)))
        {
            eBleedEff = EffectHeal((iCurrHP * -1) + 1);
            Stablize(eBleedEff, oDying);
            return;
        }
        else
        {
            eBleedEff = EffectDamage(1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBleedEff, oDying);
            oFriend = GetFirstFactionMember(oDying);
            while(GetIsObjectValid(oFriend))
            {
                if(GetArea(oFriend) == GetArea(oDying) && oFriend != oDying)
                    FloatingTextStringOnCreature(GetName(oDying) + " is bleeding to death!", oFriend, FALSE);
                oFriend = GetNextFactionMember(oDying);
            }
        }
        /* -10 hit points is the death threshold, at or beyond it the character dies */
        if (iCurrHP <= -10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDying);
            return;
        }
        object oHench = GetHenchman();
        if (GetIsObjectValid(oHench))
        {
            // Henchman comes to heal
            AssignCommand(oHench,RespondToShout(oDying, ASSOCIATE_COMMAND_HEALMASTER));
        }

        DelayCommand(fBleedDelay, Bleed());
    }
}

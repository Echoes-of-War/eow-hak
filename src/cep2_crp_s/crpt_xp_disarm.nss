//trap xp award script - c.r.a.p. player action widget
#include "crp_inc_paw"

void main()
{
    object oRogue = GetLastDisarmed();
    object oTrigger = GetNearestObject(OBJECT_TYPE_TRIGGER);
    int nRogueLevel = GetHitDice(oRogue);

    int nDisarmSkill = GetSkillRank(SKILL_DISABLE_TRAP, oRogue);
    int nTrapDC = GetTrapDisarmDC(OBJECT_SELF);
    float fXPMod = 3.5;

    //the math
    int nXPAward = FloatToInt((nTrapDC * fXPMod) - (nRogueLevel * nDisarmSkill));
    crp_GiveNearbyPartyXP(oRogue, nXPAward, "Trap Disarmed - ");
}

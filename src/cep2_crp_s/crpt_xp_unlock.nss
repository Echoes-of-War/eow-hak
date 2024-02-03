#include "crp_inc_paw"

void main()
{
    object oRogue = GetLastUnlocked();
    if(GetLocalInt(OBJECT_SELF, "UNLOCKED") == 1)
        return;

    SetLocalInt(OBJECT_SELF, "UNLOCKED", 1);

    int nRogueLevel = GetHitDice(oRogue);
    int nUnlockSkill = GetSkillRank(SKILL_OPEN_LOCK, oRogue);
    int nLockDC = GetLockUnlockDC(OBJECT_SELF);
    float fXPMod = 2.5;

    //the math
    int nXPAward = FloatToInt((nLockDC * fXPMod) - (nRogueLevel * nUnlockSkill));
    crp_GiveNearbyPartyXP(oRogue, nXPAward, "Lock Picked - ");
}

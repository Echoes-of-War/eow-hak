#include "crp_inc_ddr"
void main()
{
    object oDead = GetPCSpeaker();
    int nXP = GetXP(oDead);
    int nHD = GetHitDice(oDead);
    int nPenalty = CRP_XP_LOSS_ON_DEATH * nHD;
    // * You can not lose a level with this respawning
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    int nNewXP = nXP - nPenalty;
    if (nNewXP < nMin)
       nNewXP = nMin;
    FloatingTextStringOnCreature("XP Penalty", oDead, FALSE);
    SetXP(oDead, nNewXP);
}

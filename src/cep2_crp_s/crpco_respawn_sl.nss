#include "nw_i0_plot"
#include "crp_inc_move"
void main()
{
    object oPC = GetPCSpeaker();
    string sDeity = GetDeity(oPC);
    effect eVisual = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    object oRespawn = GetObjectByTag("SR_"+sDeity);
    if(!GetIsObjectValid(oRespawn))
        oRespawn = GetObjectByTag("SR_");

    SetRacialMovementRate(oPC);
    SetCutsceneMode(oPC, TRUE);
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(0.5, RemoveEffects(oPC));
    DelayCommand(1.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 8.0)));
    DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC, 3.0f));
    DelayCommand(5.5, FadeToBlack(oPC));
    DelayCommand(6.0, AssignCommand(oPC, ActionJumpToObject(oRespawn)));
    DelayCommand(12.0, FadeFromBlack(oPC));
    DelayCommand(15.0, SetCutsceneMode(oPC, FALSE));
}

#include "crp_inc_area"
void main()
{
    object oPC = GetExitingObject();
    effect eRemove = GetFirstEffect(oPC);
    int nEffect;
    while(GetIsEffectValid(eRemove))
    {
        nEffect = GetEffectType(eRemove);
        //SendMessageToPC(oPC, IntToString(nEffect));
        if(nEffect == 74 || nEffect == 37)
        {
            RemoveEffect(oPC, eRemove);
        }
        eRemove = GetNextEffect(oPC);
    }
    DelayCommand(2.0, ClearArea());
}

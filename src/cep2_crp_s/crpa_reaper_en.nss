#include "crp_inc_area"
void main()
{
    object oPC = GetEnteringObject();

    if(GetIsPC(oPC) && !GetIsDM(oPC))
    {
        if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)))
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            object oItem = CreateItemOnObject("crpi_deathrobe", oPC);
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
        }

        //Only used in the PW Base Mod
        //SetLastLocation(oPC);

        effect eGhost = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
        effect eSlow = EffectSlow(); //EffectHaste();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, oPC, 9999.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oPC, 9999.0);
    }
}

#include "crp_inc_move"
void main()
{
    //If in crafting mode, exit
    if(GetLocalInt(OBJECT_SELF, "X2_L_CRAFT_MODIFY_MODE") == TRUE)
        return;

    //If armor encumbrance rules are not in effect, exit
    if(GetLocalInt(GetModule(), "NO_ARMOR_ENCUMBRANCE") == 1)
        return;

    int nMode = GetLocalInt(OBJECT_SELF, "EQUIP_MODE");
    switch(nMode)
    {
        case 1: EffectArmorEncumbrance(OBJECT_SELF); return;
        case 2: RemoveArmorEncumbrance(OBJECT_SELF); return;
    }
}

void ModifyAppearance(object oPC, object oArmor, int nApp)
{
    object oNew = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK, nApp, TRUE);
    DestroyObject(oArmor);
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
}
void main()
{
    object oPC = OBJECT_SELF;
        if (GetLocalInt(oPC, "NoCloak") == 1) return;
    object oItem;
    int nMode = GetLocalInt(oPC, "EQUIP_MODE");

    if(nMode == 1)
        oItem = GetPCItemLastEquipped();
    else
        oItem = GetPCItemLastUnequipped();

    if(GetBaseItemType(oItem) != BASE_ITEM_CLOAK) return;

    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if(!GetIsObjectValid(oArmor))
        return;
    if(nMode == 2)
    {
        ModifyAppearance(oPC, oArmor, 1);
        return;
    }
    else
    {
        ModifyAppearance(oPC, oArmor, 112); //154,7
    }
}

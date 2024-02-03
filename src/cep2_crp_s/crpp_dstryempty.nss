void main()
{
    object oPC = GetLastDisturbed();
    if(!GetIsPC(oPC)) return;
    object oItem = GetInventoryDisturbItem();
    if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        ActionGiveItem(oItem, oPC);
    }
    else
    {
        oItem = GetFirstItemInInventory(OBJECT_SELF);
        if(!GetIsObjectValid(oItem))
            DestroyObject(OBJECT_SELF);
    }
}

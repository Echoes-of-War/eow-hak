void main()
{
    object oInv = GetLocalObject(OBJECT_SELF, "INVENTORY");
    object oItem = GetFirstItemInInventory();

    if(!GetIsObjectValid(oItem))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }
    while(GetIsObjectValid(oItem))
    {
        ActionGiveItem(oItem, oInv);
        oItem = GetNextItemInInventory();
    }
    DelayCommand(0.5, DestroyObject(OBJECT_SELF));
}

void main()
{
    if(!GetIsObjectValid(GetFirstItemInInventory(OBJECT_SELF)))
        DestroyObject(OBJECT_SELF);
}

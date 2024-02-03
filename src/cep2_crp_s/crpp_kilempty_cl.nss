//This script is used to destoy a placeable onclose if it has no more items
//in it. Useful for hidden sacks or other hidden placeables

//Todo: check if has hidden compartment before destroyed

void main()
{
    int iCount = 0;
    object oItem = GetFirstItemInInventory();
    while(GetIsObjectValid(oItem)) {
        iCount++;
        oItem = GetNextItemInInventory();
    }

    if(iCount==0) {
        DestroyObject(OBJECT_SELF,1.0);
    }
}

void main()
{
    location lLoc = GetLocation(OBJECT_SELF);
    CreateObject(OBJECT_TYPE_ITEM, "crpi_wood02", lLoc);
    object oBroken = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_brokenwood1", lLoc);
    SetLocalObject(GetLastAttacker(), "CLEANUP", oBroken);
    ExecuteScript("crpz_cleanupobj", GetLastAttacker());
}

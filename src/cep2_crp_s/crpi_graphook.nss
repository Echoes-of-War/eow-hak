void main()
{
    object oTarget = GetSpellTargetObject();

    if(GetTag(oTarget) == "crpi_rope")
    {
        DestroyObject(oTarget);
        DestroyObject(GetItemActivated());
        CreateItemOnObject("crpi_graprope");
        return;
    }
}

void main()
{
    object oPC = GetLastUsedBy();
    if(GetLocalInt(OBJECT_SELF, "STRIKE_TENT") == 0)
    {
        SetLocalInt(OBJECT_SELF, "STRIKE_TENT", 1);
        FloatingTextStringOnCreature("click again to strike tent.", GetLastUsedBy());
        DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "STRIKE_TENT"));
    }
    else
    {
        string sSfx = GetStringRight(GetResRef(OBJECT_SELF), 2);
        CreateItemOnObject("crpi_adv_tent" + sSfx, GetLastUsedBy(), 1);
        DestroyObject(OBJECT_SELF);
    }
}

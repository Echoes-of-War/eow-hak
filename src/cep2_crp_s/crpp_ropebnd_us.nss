void main()
{
    object oPC = GetLastUsedBy();
    object oJumpTo = GetLocalObject(OBJECT_SELF, "ROPE");
    if(GetIsObjectValid(oJumpTo))
    {
        ActionStartConversation(oPC, "crpco_rope", TRUE, FALSE);
    }
    else
    {
        CreateItemOnObject("crpi_rope", oPC, 1);
        DestroyObject(OBJECT_SELF);
    }
}

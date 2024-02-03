void main()
{
    object oPC = GetExitingObject();
    if(GetIsPC(oPC))
        SetLocalInt(oPC, "NO_REST", 1);
}

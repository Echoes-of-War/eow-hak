void main()
{
    object oPC = GetEnteringObject();
    if(GetIsPC(oPC))
        SetLocalInt(oPC, "NO_REST", 0);
}

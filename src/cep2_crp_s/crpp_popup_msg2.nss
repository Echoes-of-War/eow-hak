void main()
{
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    float fDis = GetDistanceBetween(OBJECT_SELF, oPC);
    if(fDis != 0.0f
       && fDis < IntToFloat(GetReflexSavingThrow(OBJECT_SELF))
       && !GetLocalInt(OBJECT_SELF, "DO_ONCE"))
    {
        SetLocalInt(OBJECT_SELF, "DO_ONCE", 1);
        string sMsg = GetLocalString(OBJECT_SELF, "MESSAGE");
        SpeakString(sMsg);
        DelayCommand(30.0f, DestroyObject(OBJECT_SELF));
    }
}

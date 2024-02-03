void main()
{
    object oVictim = GetEnteringObject();
    object oPit = GetNearestObjectByTag("SCPIT");
    AssignCommand(oVictim, PlaySound("as_cv_brickscrp2"));
    location lPit = GetLocation(oPit);
    string sDrop = GetLocalString(oPit, "DESTINATION");
    string sResRef = GetLocalString(oPit, "RESREF");
    int nLevel = GetLocalInt(OBJECT_SELF, "DAMAGE_LEVEL");
    int nDamage = (nLevel * GetMaxHitPoints(oVictim)) / 5;
    object oNewPit = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPit, FALSE, "PIT");
    SetLocalString(oNewPit, "DESTINATION", sDrop);
                           //16
    if(ReflexSave(oVictim, 25, SAVING_THROW_TYPE_TRAP, OBJECT_SELF) == 0)
    {
        SetLocalObject(oVictim, "PIT_DROP", GetObjectByTag(sDrop));
        SetLocalInt(oVictim, "DROP_DAMAGE", nDamage);
        ExecuteScript("crpt_pitfall", oVictim);
    }
    else
    {
        AssignCommand(oVictim, PlayVoiceChat(VOICE_CHAT_PAIN1));
        FloatingTextStringOnCreature("You barely avoid falling into a hidden pit!", oVictim, FALSE);
    }
}

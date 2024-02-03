int StartingConditional()
{
    if(GetLocalInt(GetPCSpeaker(),"IsAFK"))
        return FALSE;

    return TRUE;
}

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(),"IsAFK");
    return iResult;
}

void main()
{
    object oCleanup = GetLocalObject(OBJECT_SELF, "CLEANUP");
    DeleteLocalObject(OBJECT_SELF, "CLEANUP");
    DelayCommand(4.0, DestroyObject(oCleanup));
}

void main()
{
    int nDemo = GetLocalInt(OBJECT_SELF, "DEMO");
    SetLocalInt(GetEnteringObject(), "DEMO", nDemo);
}

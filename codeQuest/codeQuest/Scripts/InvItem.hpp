#pragma once

#include <iostream>

using std::string;

class InvItem {

    public:
        int id; // Indicates location in inventory order
        int quantity; // Indicates amount of this item in inventory
        string name; // Item name as it appears to player
        InvItem *next; // Next item in list

        InvItem(int id, int quantity, string name, InvItem *next);

    private:

};
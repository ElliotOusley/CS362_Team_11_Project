#include <iostream>
#include "InvItem.hpp"

// Instantiate an inventory item
InvItem::InvItem(int id, int quantity, string name, InvItem *next) {
    this->id = id;
    this->quantity = quantity;
    this->name = name;
    this->next = next;
};
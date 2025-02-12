#include <iostream>
#include "InvList.hpp"

///////////////////////////////////////////////////////////////////////////////
// List creation and destruction
InvList::InvList() {
    this->root = nullptr;
    this->count = 0;
};

InvList::~InvList() {
    while (this->count > 0) {
        this->remove(this->root, this->root->quantity);
    };
};

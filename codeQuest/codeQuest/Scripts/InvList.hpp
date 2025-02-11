#pragma once

#include "InvItem.hpp"

#include <iostream>

using std::string;

class InvList {

    public:
    InvItem *root;
    int count;

    InvList();
    ~InvList();

    void add(InvItem item, int AddQuantity);
    void remove(InvItem item, int AddQuantity);

    private:
    InvItem *search(string SearchItem);

};
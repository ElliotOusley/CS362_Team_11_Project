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

    // add to existing quantity of item, or create new item 
    void add(InvItem *item, int AddQuantity); 
    // Subtract from existing quantity of item
    void remove(InvItem *item, int SubQuantity);

    private:
    InvItem *search(string SearchItem); // Find item in list
    void insert(InvItem InsItem); // Add new item to list

};
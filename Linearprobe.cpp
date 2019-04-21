/**
 * @file lphashtable.cpp
 * Implementation of the LPHashTable class.
 */
#include "lphashtable.h"
using std::pair;
using hashes::hash;

template <class K, class V>
LPHashTable<K, V>::LPHashTable(size_t tsize)
{
    if (tsize <= 0)
        tsize = 17;
    size = findPrime(tsize);
    table = new std::pair<K, V>*[size];
    should_probe = new bool[size];
    for (size_t i = 0; i < size; i++) {
        table[i] = NULL;
        should_probe[i] = false;
    }
    elems = 0;
}

template <class K, class V>
LPHashTable<K, V>::~LPHashTable()
{
    for (size_t i = 0; i < size; i++)
        delete table[i];
    delete[] table;
    delete[] should_probe;
}

template <class K, class V>
LPHashTable<K, V> const& LPHashTable<K, V>::operator=(LPHashTable const& rhs)
{
    if (this != &rhs) {
        for (size_t i = 0; i < size; i++)
            delete table[i];
        delete[] table;
        delete[] should_probe;

        table = new std::pair<K, V>*[rhs.size];
        should_probe = new bool[rhs.size];
        for (size_t i = 0; i < rhs.size; i++) {
            should_probe[i] = rhs.should_probe[i];
            if (rhs.table[i] == NULL)
                table[i] = NULL;
            else
                table[i] = new std::pair<K, V>(*(rhs.table[i]));
        }
        size = rhs.size;
        elems = rhs.elems;
    }
    return *this;
}

template <class K, class V>
LPHashTable<K, V>::LPHashTable(LPHashTable<K, V> const& other)
{
    table = new std::pair<K, V>*[other.size];
    should_probe = new bool[other.size];
    for (size_t i = 0; i < other.size; i++) {
        should_probe[i] = other.should_probe[i];
        if (other.table[i] == NULL)
            table[i] = NULL;
        else
            table[i] = new std::pair<K, V>(*(other.table[i]));
    }
    size = other.size;
    elems = other.elems;
}

template <class K, class V>
void LPHashTable<K, V>::insert(K const& key, V const& value)
{
     elems++;
     if(shouldResize()){
         resizeTable();
     }
     size_t i = hash(key, size);
     while(table[i] != NULL){
         i = (i+1) % size;
     }
     table[i] = new pair <K, V>(key, value);
     should_probe[i] = true;
}

template <class K, class V>
void LPHashTable<K, V>::remove(K const& key)
{
    int i = findIndex(key);
    if( i != -1 ) {
        delete table[i];
        table[i] = NULL;
        elems--;
    }
}

template <class K, class V>
int LPHashTable<K, V>::findIndex(const K& key) const
{
    size_t i = hash(key, size);
    size_t ending = i;

    while(should_probe[i]){
        if(table[i] != NULL && table[i]->first == key){
            return i;
        }
        i = (i+1) % size;
        if(i == ending){
            break;
        }
    }
    return -1;
}

template <class K, class V>
V LPHashTable<K, V>::find(K const& key) const
{
    int idx = findIndex(key);
    if (idx != -1)
        return table[idx]->second;
    return V();
}

template <class K, class V>
V& LPHashTable<K, V>::operator[](K const& key)
{
    // First, attempt to find the key and return its value by reference
    int idx = findIndex(key);
    if (idx == -1) {
        // otherwise, insert the default value and return it
        insert(key, V());
        idx = findIndex(key);
    }
    return table[idx]->second;
}

template <class K, class V>
bool LPHashTable<K, V>::keyExists(K const& key) const
{
    return findIndex(key) != -1;
}

template <class K, class V>
void LPHashTable<K, V>::clear()
{
    for (size_t i = 0; i < size; i++)
        delete table[i];
    delete[] table;
    delete[] should_probe;
    table = new std::pair<K, V>*[17];
    should_probe = new bool[17];
    for (size_t i = 0; i < 17; i++)
        should_probe[i] = false;
    size = 17;
    elems = 0;
}

template <class K, class V>
void LPHashTable<K, V>::resizeTable()
{
    size_t changedSize = findPrime(size * 2);
    std::pair<K, V>** newTable = new std::pair<K, V>*[changedSize];
    delete[] should_probe;
    should_probe = new bool[changedSize];
    for (size_t i = 0; i < changedSize; i++) {
        newTable[i] = NULL;
        should_probe[i] = false;
    }

    for(size_t i = 0; i < size; i++){
        if (table[i] != NULL) {
            size_t index = hash(table[i]->first, changedSize);
            while (newTable[index] != NULL){
                index = (index+1) % changedSize;
            }
            newTable[index] = table[i];
            should_probe[index] = true;
        }
    }
    delete[] table;
    table = newTable;
    size = changedSize;
}

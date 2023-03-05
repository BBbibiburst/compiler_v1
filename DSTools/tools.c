#pragma once
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
enum lexical_unit {INT = 0,FLOAT,ID,SEMI,COMMA,ASSIGNOP,RELOP,PLUS,MINUS,STAR,DIV,AND,
    OR,DOT,NOT,TYPE,LP,RP,LB,RB,LC,RC,STRUCT,RETURN,IF,ELSE,WHILE,BLANK};
struct pair{enum lexical_unit unit;char* unit_value;};
typedef struct pair pair;
struct ListNode {
    union {struct pair pair;int length;} val;
    struct ListNode *next;
};
typedef struct ListNode *List;
List MakeList(){
    List node = (struct ListNode *)malloc(sizeof(struct ListNode));
    node->val.length = 0;
    node->next = NULL;
    return node;
}
void ListAdd(List head,int pos,struct pair val){
    head->val.length++;
    List node_list = head;
    for(int i = 0;i<pos;i++){
        if(node_list->next)
            node_list = node_list->next;
        else {
            head->val.length--;
            return;
        }
    }
    List next = node_list->next;
    List node = (struct ListNode *)malloc(sizeof(struct ListNode));
    node_list->next = node;
    node->val.pair = val;
    node->next = next;
}
void ListDelete(List head,int pos){
    head->val.length--;
    List node_list = head;
    for(int i = 0;i<pos;i++){
        if(node_list->next)
            node_list = node_list->next;
        else {
            head->val.length++;
            return;
        }
    }
    List next = node_list->next;
    List nextnext = next->next;
    node_list->next = nextnext;
    free(next);
}
struct pair ListRetrieve(List head,int pos){
    List node_list = head;
    for(int i = 0;i<=pos;i++){
        if(node_list->next)
            node_list = node_list->next;
        else {
            struct pair null_pair = {0,"NULL"};
            return null_pair;
        }
    }
    return node_list->val.pair;
}
void ListUpdate(List head,int pos,struct pair val){
    List node_list = head;
    for(int i = 0;i<=pos;i++){
        if(node_list->next)
            node_list = node_list->next;
        else {
            return;
        }
    }
    node_list->val.pair = val;
}
int ListLength(List head){
    return head->val.length;
}
void PrintList(List head,int mode){
    if(!head->next){
        printf("[]\n");
        return;
    }
    if(mode==0){
        if(head->val.length==1){
            printf("[(%d,%s)]\n",head->next->val.pair.unit,head->next->val.pair.unit_value);
        }
        else{
            printf("[(%d,%s)",head->next->val.pair.unit,head->next->val.pair.unit_value);
            head=head->next->next;
            while(head){
                printf(",(%d,%s)",head->val.pair.unit,head->val.pair.unit_value);
                head = head->next;
            }
            printf("]\n");
        }
    }
    else if(mode == 1){
        if(head->val.length==1){
            printf("[%d]\n",head->next->val.pair.unit);
        }
        else{
            printf("[%d",head->next->val.pair.unit);
            head=head->next->next;
            while(head){
                printf(",%d",head->val.pair.unit);
                head = head->next;
            }
            printf("]\n");
        }
    }
}

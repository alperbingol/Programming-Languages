

struct Node {
  char* vrb;
  int line;
  struct Node* next;
};
typedef struct Node Node;


struct stack {
  Node* top;
  int size;
};
typedef struct stack stack;

stack* Investigator;

void Control(char* name, int* final) {
  *final = 0;
  Node* ptr = Investigator->top;
  int i;
  for(i = 0; i < Investigator->size; i++) {
    if(!strcmp(ptr->vrb, name)) {
      *final = 1;
      return;
    }
    ptr = ptr->next;
  }
}

void Pushing(char* name, int line, int* final) {
  
  Control(name, final);
  if(*final)
    *final = 0;
  else{
    
    Node* ptr = (Node*)malloc(sizeof(Node));
    ptr->vrb = (char*)malloc(strlen(name));
    memcpy(ptr->vrb, name, strlen(name));
    ptr->line = line;
    ptr->next = Investigator->top;
    Investigator->top = ptr;
    Investigator->size++;
    *final = 1;
  }
}


void first() {
  Investigator = (stack*)malloc(sizeof(stack));
  Investigator->top = NULL;
}

void Popping(int line) {
  Node* ptr = Investigator->top;
  while(Investigator->top != (Node*) 0 && Investigator->top->line >= line) {
    Investigator->top = Investigator->top->next;
    free(ptr);
    ptr = Investigator->top;
    Investigator->size--;
  }
}


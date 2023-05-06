#include <stdlib.h>

#ifndef MYQUEUE_H
#define MYQUEUE_H

typedef struct myqueue
{
	size_t head;
	size_t tail;
	size_t size;
	void **data;
} myqueue;

int mypush(myqueue *q, void *data)
{
	if (((q->head + 1) % q->size) == q->tail)
	{
		return -1;
	}

	q->data[q->head] = data;
	q->head = (q->head + 1) % q->size;
	return 0;
}

void *mypop(myqueue *q)
{
	if (q->tail == q->head)
	{
		return NULL;
	}

	void *handle = q->data[q->tail];
	q->data[q->tail] = NULL;
	q->tail = (q->tail + 1) % q->size;
	return handle;
}

int getsize(myqueue *q){

  int res = q->tail - q->head;
  if(res == NULL){
    return 0;
  } 
  return res;
}

#endif
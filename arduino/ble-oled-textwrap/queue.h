#include <stdlib.h>

#ifndef MYQUEUE_H
#define MYQUEUE_H

typedef struct myqueue
{
	size_t head;
	size_t tail;
	size_t size;
	char **data;
} myqueue;

int get_scroll(int scroll_speed)
{
	switch (scroll_speed)
	{
	case 0:
		return 1000;
	case 1:
		return 500;
	case 2:
		return 100;

	default:
		return 1000;
		break;
	}
}

int mypush(myqueue *q, char *data)
{
	if (((q->head + 1) % q->size) == q->tail)
	{
		return -1;
	}

	q->data[q->head] = data;
	q->head = (q->head + 1) % q->size;
	return 0;
}

char *mypop(myqueue *q)
{
	if (q->tail == q->head)
	{
		return NULL;
	}

	char *handle = q->data[q->tail];
	q->data[q->tail] = NULL;
	q->tail = (q->tail + 1) % q->size;
	return handle;
}

int getsize(myqueue *q)
{

  if(q == NULL){
    return 0;
  }

  if(q->tail == NULL || q->head == NULL){
    return 0;
  }
    
	return q->tail - q->head;
}

#endif

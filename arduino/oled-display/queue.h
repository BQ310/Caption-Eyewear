#include <stdlib.h>

typedef struct queue_t
{
	size_t head;
	size_t tail;
	size_t size;
	void **data;
} queue_t;

int push(queue_t *q, void *data)
{
	if (((q->head + 1) % q->size) == q->tail)
	{
		return -1;
	}

	q->data[q->head] = data;
	q->head = (q->head + 1) % q->size;
	return 0;
}

void *pop(queue_t *q)
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
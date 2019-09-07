#pragma once

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<strings.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<netinet/ip.h>
#include<arpa/inet.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include<pthread.h>
#include<strings.h>

#define IP "192.168.7.23"

void sys_err(char *argc);
void *functions (void *argc);



#include <sys/time.h>

float time_use=0;
struct timeval start;
struct timeval end;//struct timezone tz; 
gettimeofday(&start,NULL); //gettimeofday(&start,&tz);
while(access(usbpath[i-1].path, F_OK)){
    usleep(100);
    gettimeofday(&end,NULL);
    time_use=(end.tv_sec-start.tv_sec)*1000000+(end.tv_usec-start.tv_usec);
    if(time_use>=6000000){
		printf("over time!\n");
        break;
	}
} 
#include <sys/select.h>

int select_covertime(char *ret_msg)
{
	struct timeval timeout = {2, 0};
	int fd;
	fd_set fds;
	FD_ZERO(&fds);

	while(1){
		FD_SET(0, &fds);
		FD_SET(fd, &fds);
		
		int ret = select(fd+1,&fds,NULL,NULL, &timeout);
		if(ret < 0){
			perror("select ");
			break;
		}else if(ret > 0){//有集合响应
			if(FD_ISSET(fd, &fds)){
				read(fd, ret_msg, 10);
			break;
			}
		}else{
			printf("tty read time out");

			break;
		}
	}
	close(fd);
}

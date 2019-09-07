static int get_time(char *time_buff)
{
	time_t rawtime;
	struct tm *info;
	time(&rawtime);
	info = localtime(&rawtime);
	snprintf(time_buff, 80, "%d-%02d-%02d %02d:%02d:%02d", info->tm_year+1900, info->tm_mon+1, info->tm_mday, info->tm_hour, info->tm_min, info->tm_sec);
	return 0;
}
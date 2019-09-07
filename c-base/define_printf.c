#if 1
#define DEBUG(format,...) printf(YELLOW"[%s]-->%d:"NONE" "format"\n", __func__, __LINE__, ##__VA_ARGS__)
#else
#define	DEBUG(fmt,...)
#endif
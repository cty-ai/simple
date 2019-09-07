//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	> File Name: 7.c
//	> Created Time: 2018年09月29日 星期六 16时52分52秒
//______________________________________________________

#include<stdio.h>

int main(void)
{
	
	int i,j,t,n;
	printf("请输入元素个数:\n");
	scanf("%d",&n);
	int a[n];
	for(i=0;i<n;i++)
	scanf("%d",&a[i]);

	for(i=0;i<n;i++)
	{
		for(j=0;j<n-1;j++)
		{
			if(a[j]>a[j+1])
			{
			t=a[j];
			a[j]=a[j+1];
			a[j+1]=t;
			}
		}
	}
	for(i=0;i<n;i++)
	printf("%d\n",a[i]);
	


}

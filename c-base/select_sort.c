void select_sort(int*a,int n)
 
{
 
    register int i,j,min,t;
 
    for(i=0;i<n-1;i++)
 
    {
 
        min=i;//查找最小值
 
        for(j=i+1;j<n;j++)
 
            if(a[min]>a[j])
 
                min=j;//交换
 
        if(min!=i)
 
        {
 
            t=a[min];
 
            a[min]=a[i];
 
            a[i]=t;
 
        }
 
    }
 
}
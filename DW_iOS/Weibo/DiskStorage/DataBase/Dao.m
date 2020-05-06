//
//  Person.m
//  DYZB
//
//  Created by hairong chen on 2020/3/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

#import "Dao.h"

@implementation Dao

void max(int a){
    printf("%d\n",a);
}

void (*zp)(int a);




- (void)test {
    zp = max;
    (***********zp)(1);
    
    zp = &max;
    zp(1);
    
    int t = 16;
    int *po = &t;
    int **pn = &po;
    
    
    int a[10] = {12,3,4,5,6,7,8,9,10};
    NSLog(@"a=%p,&a=%p",a,&a);
    int(*p)[10] = &a;//代表是整个数组的地址，因此需要使用数组指针
    int(*p1)[10] = a;//代表只是第一个元素的地址
    int *p2 = a;
    int *p3 = &a[0];
    NSLog(@"p=%p,&p1=%p,&p2=%p,&p3=%p,",p+1,p1+1,p2+1,p3+1);
    
    for(int i=0;i< 10;i++){
        printf( "%p " , (p + i)) ;
        printf( "%p " , (p3 + i)) ;
    }
 }

@end
